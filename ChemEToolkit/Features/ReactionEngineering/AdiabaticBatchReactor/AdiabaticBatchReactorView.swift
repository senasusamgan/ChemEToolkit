import SwiftUI

struct AdiabaticBatchReactorView:
    View {

    @State private var concentrationInput = "100"
    @State private var factorInput = "1000000"
    @State private var activationEnergyInput = "50000"
    @State private var temperatureInput = "350"
    @State private var temperatureRiseInput = "100"
    @State private var conversionInput = "0.8"

    @State private var result:
        AdiabaticBatchReactorResult?

    @State private var errorMessage = ""

    private let engine =
        AdiabaticBatchReactorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "flame.fill",
                    title:
                        "Adiabatic Batch Reactor",
                    subtitle:
                        "Calculate time and temperature for a target first-order conversion",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Adiabatic Temperature–Conversion Relation")
                            .font(.headline)

                        Text("T = T₀ + ΔT_ad X")
                            .font(
                                .system(
                                    size: 20,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "A positive ΔT_ad models exothermic heating; a negative value models adiabatic cooling."
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
                            placeholder: "Example: 100",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title:
                                "Pre-Exponential Factor",
                            symbol: "A",
                            unit: "1/s",
                            placeholder: "Example: 1000000",
                            text: $factorInput
                        )

                        EngineeringInputField(
                            title:
                                "Activation Energy",
                            symbol: "E_a",
                            unit: "J/mol",
                            placeholder: "Example: 50000",
                            text:
                                $activationEnergyInput
                        )

                        EngineeringInputField(
                            title:
                                "Initial Temperature",
                            symbol: "T₀",
                            unit: "K",
                            placeholder: "Example: 350",
                            text: $temperatureInput
                        )

                        EngineeringInputField(
                            title:
                                "Adiabatic Temperature Rise",
                            symbol: "ΔT_ad",
                            unit: "K at X = 1",
                            placeholder: "Example: 100",
                            text:
                                $temperatureRiseInput
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
                                "Calculate Batch Time",
                            systemImage:
                                "flame.fill",
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
                                            unit: "s"
                                        ),
                                        .init(
                                            label:
                                                "Isothermal Time at T₀",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .isothermalTimeAtInitialTemperature
                                                ),
                                            unit: "s"
                                        ),
                                        .init(
                                            label:
                                                "Isothermal / Adiabatic Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .isothermalToAdiabaticTimeRatio
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Final Temperature",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalTemperature
                                                ),
                                            unit: "K"
                                        ),
                                        .init(
                                            label:
                                                "Final Rate Constant",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalRateConstant
                                                ),
                                            unit: "1/s"
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
        .navigationTitle("Adiabatic Batch")
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
                            fieldName:
                                "initial concentration A"
                        ),
                    preExponentialFactor:
                        try InputValidator.parseNumber(
                            factorInput,
                            fieldName:
                                "pre-exponential factor"
                        ),
                    activationEnergy:
                        try InputValidator.parseNumber(
                            activationEnergyInput,
                            fieldName:
                                "activation energy"
                        ),
                    initialTemperature:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName:
                                "initial temperature"
                        ),
                    adiabaticTemperatureRise:
                        try InputValidator.parseNumber(
                            temperatureRiseInput,
                            fieldName:
                                "adiabatic temperature rise"
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
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "100"
        factorInput = "1000000"
        activationEnergyInput = "50000"
        temperatureInput = "350"
        temperatureRiseInput = "100"
        conversionInput = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        factorInput = ""
        activationEnergyInput = ""
        temperatureInput = ""
        temperatureRiseInput = ""
        conversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AdiabaticBatchReactorView()
    }
}
