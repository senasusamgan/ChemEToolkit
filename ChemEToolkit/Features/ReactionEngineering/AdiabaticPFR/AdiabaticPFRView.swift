import SwiftUI

struct AdiabaticPFRView:
    View {

    @State private var concentrationInput = "100"
    @State private var flowRateInput = "0.01"
    @State private var factorInput = "1000000"
    @State private var activationEnergyInput = "50000"
    @State private var temperatureInput = "350"
    @State private var temperatureRiseInput = "100"
    @State private var conversionInput = "0.8"

    @State private var result:
        AdiabaticPFRResult?

    @State private var errorMessage = ""

    private let engine =
        AdiabaticPFREngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "flame.circle.fill",
                    title: "Adiabatic PFR",
                    subtitle:
                        "Integrate reactor volume as temperature changes with conversion",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Adiabatic PFR Design")
                            .font(.headline)

                        Text(
                            "τ = ∫ dX/[k(T)(1−X)]"
                        )
                        .font(
                            .system(
                                size: 18,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Arrhenius kinetics and the adiabatic energy balance are evaluated throughout the reactor."
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
                                "Inlet Temperature",
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
                                "Size Adiabatic PFR",
                            systemImage:
                                "flame.circle.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Required Reactor Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredReactorVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "Required Space Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredSpaceTime
                                                ),
                                            unit: "s"
                                        ),
                                        .init(
                                            label:
                                                "Outlet Temperature",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .outletTemperature
                                                ),
                                            unit: "K"
                                        ),
                                        .init(
                                            label:
                                                "Outlet Rate Constant",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .outletRateConstant
                                                ),
                                            unit: "1/s"
                                        ),
                                        .init(
                                            label:
                                                "Isothermal Reactor Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .isothermalReactorVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "Isothermal / Adiabatic Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .isothermalToAdiabaticVolumeRatio
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
        .navigationTitle("Adiabatic PFR")
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
                    inletTemperature:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName:
                                "inlet temperature"
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
        flowRateInput = "0.01"
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
        flowRateInput = ""
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
        AdiabaticPFRView()
    }
}
