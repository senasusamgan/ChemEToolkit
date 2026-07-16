import SwiftUI

struct HeatExchangeBatchReactorView: View {
    @State private var concentrationInput = "100"
    @State private var factorInput = "1000000"
    @State private var activationInput = "50000"
    @State private var initialTemperatureInput = "350"
    @State private var adiabaticRiseInput = "100"
    @State private var coolantInput = "330"
    @State private var removalInput = "0.05"
    @State private var conversionInput = "0.8"
    @State private var maximumTimeInput = "200"

    @State private var result: HeatExchangeBatchReactorResult?
    @State private var errorMessage = ""

    private let engine = HeatExchangeBatchReactorEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "thermometer.and.liquid.waves",
                    title: "Heat-Exchange Batch Reactor",
                    subtitle: "Integrate batch conversion and temperature with coolant heat removal",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("dT/dt = ΔT_ad·dX/dt − h(T−T_c)")
                            .font(.headline)

                        Text("The coupled balances are integrated with a fourth-order Runge–Kutta method.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Initial Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 100",
                            text: $concentrationInput
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
                            title: "Initial Temperature",
                            symbol: "T₀",
                            unit: "K",
                            placeholder: "Example: 350",
                            text: $initialTemperatureInput
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
                            title: "Heat-Removal Coefficient",
                            symbol: "h",
                            unit: "1/s",
                            placeholder: "Example: 0.05",
                            text: $removalInput
                        )

                        EngineeringInputField(
                            title: "Target Conversion",
                            symbol: "X_A",
                            unit: "—",
                            placeholder: "Example: 0.8",
                            text: $conversionInput
                        )

                        EngineeringInputField(
                            title: "Maximum Integration Time",
                            symbol: "t_max",
                            unit: "s",
                            placeholder: "Example: 200",
                            text: $maximumTimeInput
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
                            systemImage: "thermometer.and.liquid.waves",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Time to Target Conversion",
                                            value: numberFormatter.format(result.timeToTargetConversion),
                                            unit: "s"
                                        ),
                                        .init(
                                            label: "Final Temperature",
                                            value: numberFormatter.format(result.finalTemperature),
                                            unit: "K"
                                        ),
                                        .init(
                                            label: "Maximum Temperature",
                                            value: numberFormatter.format(result.maximumTemperature),
                                            unit: "K"
                                        ),
                                        .init(
                                            label: "Final Concentration A",
                                            value: numberFormatter.format(result.finalConcentrationA),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label: "Final Rate Constant",
                                            value: numberFormatter.format(result.finalRateConstant),
                                            unit: "1/s"
                                        ),
                                        .init(
                                            label: "Heat Removed Equivalent",
                                            value: numberFormatter.format(result.heatRemovedTemperatureEquivalent),
                                            unit: "K-equivalent"
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
        .navigationTitle("Heat-Exchange Batch")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialConcentrationA:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName: "initial concentration a"
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
                    initialTemperature:
                        try InputValidator.parseNumber(
                            initialTemperatureInput,
                            fieldName: "initial temperature"
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
                    heatRemovalCoefficient:
                        try InputValidator.parseNumber(
                            removalInput,
                            fieldName: "heat-removal coefficient"
                        ),
                    targetConversion:
                        try InputValidator.parseNumber(
                            conversionInput,
                            fieldName: "target conversion"
                        ),
                    maximumIntegrationTime:
                        try InputValidator.parseNumber(
                            maximumTimeInput,
                            fieldName: "maximum integration time"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "100"
        factorInput = "1000000"
        activationInput = "50000"
        initialTemperatureInput = "350"
        adiabaticRiseInput = "100"
        coolantInput = "330"
        removalInput = "0.05"
        conversionInput = "0.8"
        maximumTimeInput = "200"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        factorInput = ""
        activationInput = ""
        initialTemperatureInput = ""
        adiabaticRiseInput = ""
        coolantInput = ""
        removalInput = ""
        conversionInput = ""
        maximumTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        HeatExchangeBatchReactorView()
    }
}
