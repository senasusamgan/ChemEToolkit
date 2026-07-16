import SwiftUI

struct DeactivatingPackedBedReactorView:
    View {

    @State private var concentrationInput =
        "2"

    @State private var flowInput =
        "1"

    @State private var catalystWeightInput =
        "10"

    @State private var rateCoefficientInput =
        "0.4"

    @State private var deactivationRateInput =
        "0.1"

    @State private var timeInput =
        "5"

    @State private var targetConversionInput =
        "0.9"

    @State private var result:
        DeactivatingPackedBedReactorResult?

    @State private var errorMessage = ""

    private let engine =
        DeactivatingPackedBedReactorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "shippingbox.and.arrow.backward.fill",
                    title:
                        "Deactivating Packed-Bed Reactor",
                    subtitle:
                        "Predict conversion loss and catalyst-weight demand with time on stream",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Activity-Adjusted Packed Bed")
                            .font(.headline)

                        Text(
                            "X = 1 − exp[−a(t)k′W/Q]"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Catalyst activity is assumed uniform throughout the packed bed."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title:
                                "Inlet Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "2",
                            text:
                                $concentrationInput
                        )

                        EngineeringInputField(
                            title:
                                "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "1",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Catalyst Weight",
                            symbol: "W",
                            unit: "kg catalyst",
                            placeholder: "10",
                            text:
                                $catalystWeightInput
                        )

                        EngineeringInputField(
                            title:
                                "Fresh-Catalyst Rate Coefficient",
                            symbol: "k′",
                            unit:
                                "m³/(kg catalyst·time)",
                            placeholder: "0.4",
                            text:
                                $rateCoefficientInput
                        )

                        EngineeringInputField(
                            title:
                                "Deactivation Rate Constant",
                            symbol: "k_d",
                            unit: "1/time",
                            placeholder: "0.1",
                            text:
                                $deactivationRateInput
                        )

                        EngineeringInputField(
                            title: "Time on Stream",
                            symbol: "t",
                            unit: "time",
                            placeholder: "5",
                            text: $timeInput
                        )

                        EngineeringInputField(
                            title:
                                "Target Conversion",
                            symbol: "X_target",
                            unit: "—",
                            placeholder: "0.9",
                            text:
                                $targetConversionInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role: .destructive,
                                action: resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage: "trash"
                                )
                            }
                        }
                        .buttonStyle(.bordered)


                        PrimaryActionButton(
                            title:
                                "Calculate Deactivating Bed",
                            systemImage:
                                "shippingbox.and.arrow.backward.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Catalyst Activity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .catalystActivity
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Fresh Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .freshConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Current Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .currentConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Outlet Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .outletConcentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Required Weight for Target",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredCatalystWeightForTarget
                                                ),
                                            unit: "kg catalyst"
                                        ),
                                        .init(
                                            label:
                                                "Required Weight Multiplier",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredWeightMultiplier
                                                ),
                                            unit: "× current weight"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(result.modelName)
                                            .font(.headline)

                                        Divider()

                                        Text(
                                            result
                                                .limitationDescription
                                        )
                                        .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(
                                message: errorMessage
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(
                .horizontal,
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle("Deactivating Packed Bed")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletConcentrationA:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName:
                                "inlet concentration A"
                        ),
                    volumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "volumetric flow rate"
                        ),
                    catalystWeight:
                        try InputValidator.parseNumber(
                            catalystWeightInput,
                            fieldName:
                                "catalyst weight"
                        ),
                    freshCatalystRateCoefficient:
                        try InputValidator.parseNumber(
                            rateCoefficientInput,
                            fieldName:
                                "fresh-catalyst rate coefficient"
                        ),
                    deactivationRateConstant:
                        try InputValidator.parseNumber(
                            deactivationRateInput,
                            fieldName:
                                "deactivation rate constant"
                        ),
                    timeOnStream:
                        try InputValidator.parseNumber(
                            timeInput,
                            fieldName:
                                "time on stream"
                        ),
                    targetConversion:
                        try InputValidator.parseNumber(
                            targetConversionInput,
                            fieldName:
                                "target conversion"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "2"
        flowInput = "1"
        catalystWeightInput = "10"
        rateCoefficientInput = "0.4"
        deactivationRateInput = "0.1"
        timeInput = "5"
        targetConversionInput = "0.9"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        flowInput = ""
        catalystWeightInput = ""
        rateCoefficientInput = ""
        deactivationRateInput = ""
        timeInput = ""
        targetConversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DeactivatingPackedBedReactorView()
    }
}
