import SwiftUI

struct PBRPressureDropEffectsView:
    View {

    @State private var catalystWeightInput = "10"
    @State private var molarFlowInput = "1"
    @State private var concentrationInput = "100"
    @State private var rateConstantInput = "0.001"
    @State private var pressureParameterInput = "0.05"
    @State private var inletPressureInput = "500000"

    @State private var result:
        PBRPressureDropEffectsResult?

    @State private var errorMessage = ""

    private let engine =
        PBRPressureDropEffectsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "gauge.with.dots.needle.33percent",
                    title:
                        "PBR Pressure-Drop Effects",
                    subtitle:
                        "Estimate pressure loss and its effect on first-order conversion",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Simplified Gas-Phase PBR")
                            .font(.headline)

                        Text(
                            "P/P₀ = √(1 − αW)"
                        )
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                        Text(
                            "The reaction balance integrates the pressure ratio over catalyst weight."
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
                            title: "Catalyst Weight",
                            symbol: "W",
                            unit: "kg catalyst",
                            placeholder: "Example: 10",
                            text: $catalystWeightInput
                        )

                        EngineeringInputField(
                            title:
                                "Inlet Molar Flow A",
                            symbol: "F_A0",
                            unit: "mol/s",
                            placeholder: "Example: 1",
                            text: $molarFlowInput
                        )

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
                                "Mass-Specific Rate Constant",
                            symbol: "k′",
                            unit: "m³/(kg·s)",
                            placeholder: "Example: 0.001",
                            text: $rateConstantInput
                        )

                        EngineeringInputField(
                            title:
                                "Pressure-Drop Parameter",
                            symbol: "α",
                            unit: "1/kg",
                            placeholder: "Example: 0.05",
                            text:
                                $pressureParameterInput
                        )

                        EngineeringInputField(
                            title: "Inlet Pressure",
                            symbol: "P₀",
                            unit: "Pa",
                            placeholder: "Example: 500000",
                            text: $inletPressureInput
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
                                "Calculate PBR Performance",
                            systemImage:
                                "gauge.with.dots.needle.33percent",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Outlet Pressure",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .outletPressure
                                                ),
                                            unit: "Pa"
                                        ),
                                        .init(
                                            label:
                                                "Pressure Drop",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .pressureDrop
                                                ),
                                            unit: "Pa"
                                        ),
                                        .init(
                                            label:
                                                "Outlet Pressure Ratio",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .outletPressureRatio
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Conversion with Pressure Drop",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionWithPressureDrop
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Conversion without Pressure Drop",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionWithoutPressureDrop
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Conversion Penalty",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionPenalty
                                                ),
                                            unit:
                                                "percentage points"
                                        ),
                                        .init(
                                            label:
                                                "Effective Catalyst Exposure",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .effectiveCatalystExposure
                                                ),
                                            unit: "kg catalyst"
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
        .navigationTitle("PBR Pressure Effects")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    catalystWeight:
                        try InputValidator.parseNumber(
                            catalystWeightInput,
                            fieldName:
                                "catalyst weight"
                        ),
                    inletMolarFlowRateA:
                        try InputValidator.parseNumber(
                            molarFlowInput,
                            fieldName:
                                "inlet molar flow A"
                        ),
                    inletConcentrationA:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName:
                                "inlet concentration A"
                        ),
                    massSpecificFirstOrderRateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "mass-specific rate constant"
                        ),
                    pressureDropParameter:
                        try InputValidator.parseNumber(
                            pressureParameterInput,
                            fieldName:
                                "pressure-drop parameter"
                        ),
                    inletPressure:
                        try InputValidator.parseNumber(
                            inletPressureInput,
                            fieldName:
                                "inlet pressure"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        catalystWeightInput = "10"
        molarFlowInput = "1"
        concentrationInput = "100"
        rateConstantInput = "0.001"
        pressureParameterInput = "0.05"
        inletPressureInput = "500000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        catalystWeightInput = ""
        molarFlowInput = ""
        concentrationInput = ""
        rateConstantInput = ""
        pressureParameterInput = ""
        inletPressureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PBRPressureDropEffectsView()
    }
}
