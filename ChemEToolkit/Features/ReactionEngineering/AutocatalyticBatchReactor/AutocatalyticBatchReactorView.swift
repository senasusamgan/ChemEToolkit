import SwiftUI

struct AutocatalyticBatchReactorView:
    View {

    @State private var concentrationAInput =
        "1"

    @State private var concentrationBInput =
        "0.1"

    @State private var rateConstantInput =
        "0.5"

    @State private var conversionInput =
        "0.9"

    @State private var result:
        AutocatalyticBatchReactorResult?

    @State private var errorMessage = ""

    private let engine =
        AutocatalyticBatchReactorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "bolt.circle.fill",
                    title:
                        "Autocatalytic Batch Reactor",
                    subtitle:
                        "Calculate batch time for A + B → 2B with product-catalyzed kinetics",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Autocatalytic Rate Law")
                            .font(.headline)

                        Text("r = kC_A C_B")
                            .font(
                                .system(
                                    size: 21,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "A positive initial B concentration is required to initiate the reaction."
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
                                "Initial Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "1",
                            text:
                                $concentrationAInput
                        )

                        EngineeringInputField(
                            title:
                                "Initial Autocatalyst B",
                            symbol: "C_B0",
                            unit: "mol/m³",
                            placeholder: "0.1",
                            text:
                                $concentrationBInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant",
                            symbol: "k",
                            unit:
                                "m³/(mol·time)",
                            placeholder: "0.5",
                            text:
                                $rateConstantInput
                        )

                        EngineeringInputField(
                            title:
                                "Target Conversion of A",
                            symbol: "X_A",
                            unit: "—",
                            placeholder: "0.9",
                            text: $conversionInput
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
                                "Calculate Autocatalytic Batch",
                            systemImage:
                                "bolt.circle.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Time to Target Conversion",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .timeToTargetConversion
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Final Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalConcentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Final Concentration B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalConcentrationB
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Conversion at Maximum Rate",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionAtMaximumRate
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Maximum Reaction Rate",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .maximumReactionRate
                                                ),
                                            unit:
                                                "mol/(m³·time)"
                                        ),
                                        .init(
                                            label:
                                                "Final Reaction Rate",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalReactionRate
                                                ),
                                            unit:
                                                "mol/(m³·time)"
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
        .navigationTitle("Autocatalytic Batch")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialConcentrationA:
                        try InputValidator.parseNumber(
                            concentrationAInput,
                            fieldName:
                                "initial concentration A"
                        ),
                    initialConcentrationB:
                        try InputValidator.parseNumber(
                            concentrationBInput,
                            fieldName:
                                "initial concentration B"
                        ),
                    rateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "rate constant"
                        ),
                    targetConversionA:
                        try InputValidator.parseNumber(
                            conversionInput,
                            fieldName:
                                "target conversion of A"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationAInput = "1"
        concentrationBInput = "0.1"
        rateConstantInput = "0.5"
        conversionInput = "0.9"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationAInput = ""
        concentrationBInput = ""
        rateConstantInput = ""
        conversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AutocatalyticBatchReactorView()
    }
}
