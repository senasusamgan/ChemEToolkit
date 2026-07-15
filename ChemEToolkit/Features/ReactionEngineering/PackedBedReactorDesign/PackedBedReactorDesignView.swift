import SwiftUI

struct PackedBedReactorDesignView:
    View {

    @State private var concentrationInput = "100"
    @State private var flowRateInput = "0.01"
    @State private var rateConstantInput = "0.002"
    @State private var conversionInput = "0.8"

    @State private var result:
        PackedBedReactorDesignResult?

    @State private var errorMessage = ""

    private let engine =
        PackedBedReactorDesignEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "shippingbox.fill",
                    title:
                        "Packed-Bed Reactor Design",
                    subtitle:
                        "Calculate catalyst weight for a target first-order conversion",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("First-Order PBR Design")
                            .font(.headline)

                        Text(
                            "W = −(v₀/k′) ln(1 − X_A)"
                        )
                        .font(
                            .system(
                                size: 18,
                                weight: .semibold
                            )
                        )

                        Text(
                            "k′ uses units of m³/(kg catalyst·s)."
                        )
                        .foregroundStyle(.secondary)
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
                            placeholder: "Example: 100",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title:
                                "Inlet Volumetric Flow",
                            symbol: "v₀",
                            unit: "m³/s",
                            placeholder: "Example: 0.01",
                            text: $flowRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Mass-Specific Rate Constant",
                            symbol: "k′",
                            unit: "m³/(kg·s)",
                            placeholder: "Example: 0.002",
                            text: $rateConstantInput
                        )

                        EngineeringInputField(
                            title: "Target Conversion",
                            symbol: "X_A",
                            unit: "—",
                            placeholder: "Example: 0.8",
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
                                "Calculate Catalyst Weight",
                            systemImage:
                                "shippingbox.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Required Catalyst Weight",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredCatalystWeight
                                                ),
                                            unit: "kg catalyst"
                                        ),
                                        .init(
                                            label:
                                                "Inlet Molar Flow A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .inletMolarFlowRateA
                                                ),
                                            unit: "mol/s"
                                        ),
                                        .init(
                                            label:
                                                "Outlet Molar Flow A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .outletMolarFlowRateA
                                                ),
                                            unit: "mol/s"
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
                                                "Catalyst Space Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .catalystSpaceTime
                                                ),
                                            unit: "kg·s/mol"
                                        ),
                                        .init(
                                            label:
                                                "First-Order Exposure",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .firstOrderExposure
                                                ),
                                            unit: "—"
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
        .navigationTitle("PBR Design")
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
                    inletVolumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowRateInput,
                            fieldName:
                                "inlet volumetric flow"
                        ),
                    massSpecificFirstOrderRateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "mass-specific rate constant"
                        ),
                    targetConversion:
                        try InputValidator.parseNumber(
                            conversionInput,
                            fieldName:
                                "target conversion"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "100"
        flowRateInput = "0.01"
        rateConstantInput = "0.002"
        conversionInput = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        flowRateInput = ""
        rateConstantInput = ""
        conversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PackedBedReactorDesignView()
    }
}
