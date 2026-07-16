import SwiftUI

struct HeatExchangeCSTRView: View {
    @State private var concentrationInput = "100"
    @State private var flowInput = "0.01"
    @State private var factorInput = "1000000"
    @State private var activationInput = "50000"
    @State private var inletTemperatureInput = "350"
    @State private var adiabaticRiseInput = "100"
    @State private var coolantInput = "330"
    @State private var removalNumberInput = "1.5"
    @State private var conversionInput = "0.8"

    @State private var result: HeatExchangeCSTRResult?
    @State private var errorMessage = ""

    private let engine = HeatExchangeCSTREngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "snowflake.circle.fill",
                    title: "Heat-Exchange CSTR",
                    subtitle: "Size a non-isothermal CSTR with coolant heat removal",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("T = (T_in + ΔT_ad X + H T_c)/(1+H)")
                            .font(.headline)

                        Text("H is the dimensionless heat-removal number UA/(ρC_pv₀).")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Inlet Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 100",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title: "Inlet Volumetric Flow",
                            symbol: "v₀",
                            unit: "m³/s",
                            placeholder: "Example: 0.01",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Pre-Exponential Factor",
                            symbol: "A",
                            unit: "1/s",
                            placeholder: "Example: 1000000",
                            text: $factorInput
                        )

                        EngineeringInputField(
                            title: "Activation Energy",
                            symbol: "E_a",
                            unit: "J/mol",
                            placeholder: "Example: 50000",
                            text: $activationInput
                        )

                        EngineeringInputField(
                            title: "Inlet Temperature",
                            symbol: "T_in",
                            unit: "K",
                            placeholder: "Example: 350",
                            text: $inletTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Adiabatic Temperature Rise",
                            symbol: "ΔT_ad",
                            unit: "K",
                            placeholder: "Example: 100",
                            text: $adiabaticRiseInput
                        )

                        EngineeringInputField(
                            title: "Coolant Temperature",
                            symbol: "T_c",
                            unit: "K",
                            placeholder: "Example: 330",
                            text: $coolantInput
                        )

                        EngineeringInputField(
                            title: "Heat-Removal Number",
                            symbol: "H",
                            unit: "—",
                            placeholder: "Example: 1.5",
                            text: $removalNumberInput
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
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }

                            Spacer()

                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "snowflake.circle.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Required Reactor Volume",
                                            value: numberFormatter.format(result.requiredReactorVolume),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label: "Required Space Time",
                                            value: numberFormatter.format(result.requiredSpaceTime),
                                            unit: "s"
                                        ),
                                        .init(
                                            label: "Outlet Temperature",
                                            value: numberFormatter.format(result.outletTemperature),
                                            unit: "K"
                                        ),
                                        .init(
                                            label: "Adiabatic Outlet Temperature",
                                            value: numberFormatter.format(result.adiabaticOutletTemperature),
                                            unit: "K"
                                        ),
                                        .init(
                                            label: "Heat Removed Equivalent",
                                            value: numberFormatter.format(result.heatRemovedTemperatureEquivalent),
                                            unit: "K-equivalent"
                                        ),
                                        .init(
                                            label: "Heat-Exchange / Adiabatic Volume",
                                            value: numberFormatter.format(result.heatExchangeToAdiabaticVolumeRatio),
                                            unit: "—"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                                        Text(result.modelName)
                                            .font(.headline)

                                        Divider()

                                        Text(result.limitationDescription)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(message: errorMessage)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Heat-Exchange CSTR")
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
                            fieldName: "inlet concentration a"
                        ),
                    inletVolumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName: "inlet volumetric flow"
                        ),
                    preExponentialFactor:
                        try InputValidator.parseNumber(
                            factorInput,
                            fieldName: "pre-exponential factor"
                        ),
                    activationEnergy:
                        try InputValidator.parseNumber(
                            activationInput,
                            fieldName: "activation energy"
                        ),
                    inletTemperature:
                        try InputValidator.parseNumber(
                            inletTemperatureInput,
                            fieldName: "inlet temperature"
                        ),
                    adiabaticTemperatureRise:
                        try InputValidator.parseNumber(
                            adiabaticRiseInput,
                            fieldName: "adiabatic temperature rise"
                        ),
                    coolantTemperature:
                        try InputValidator.parseNumber(
                            coolantInput,
                            fieldName: "coolant temperature"
                        ),
                    heatRemovalNumber:
                        try InputValidator.parseNumber(
                            removalNumberInput,
                            fieldName: "heat-removal number"
                        ),
                    targetConversion:
                        try InputValidator.parseNumber(
                            conversionInput,
                            fieldName: "target conversion"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "100"
        flowInput = "0.01"
        factorInput = "1000000"
        activationInput = "50000"
        inletTemperatureInput = "350"
        adiabaticRiseInput = "100"
        coolantInput = "330"
        removalNumberInput = "1.5"
        conversionInput = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        flowInput = ""
        factorInput = ""
        activationInput = ""
        inletTemperatureInput = ""
        adiabaticRiseInput = ""
        coolantInput = ""
        removalNumberInput = ""
        conversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        HeatExchangeCSTRView()
    }
}
