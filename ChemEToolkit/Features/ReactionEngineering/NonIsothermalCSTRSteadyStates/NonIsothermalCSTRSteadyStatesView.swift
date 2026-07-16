import SwiftUI

struct NonIsothermalCSTRSteadyStatesView: View {
    @State private var concentrationInput = "100"
    @State private var spaceTimeInput = "1"
    @State private var factorInput = "1000000"
    @State private var activationInput = "50000"
    @State private var inletTemperatureInput = "330"
    @State private var adiabaticRiseInput = "200"
    @State private var coolantInput = "300"
    @State private var removalInput = "0"

    @State private var result:
        NonIsothermalCSTRSteadyStatesResult?
    @State private var errorMessage = ""

    private let engine =
        NonIsothermalCSTRSteadyStatesEngine()
    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "point.3.filled.connected.trianglepath.dotted",
                    title:
                        "Non-Isothermal CSTR Steady States",
                    subtitle:
                        "Locate one or multiple temperature and conversion intersections",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("X_MB(T) = X_EB(T)")
                            .font(.headline)

                        Text(
                            "Highly temperature-sensitive kinetics can produce one or three physical steady states."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout.calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Inlet Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 100",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title: "Space Time",
                            symbol: "τ",
                            unit: "s",
                            placeholder: "Example: 1",
                            text: $spaceTimeInput
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
                            placeholder: "Example: 330",
                            text: $inletTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Adiabatic Temperature Rise",
                            symbol: "ΔT_ad",
                            unit: "K",
                            placeholder: "Example: 200",
                            text: $adiabaticRiseInput
                        )

                        EngineeringInputField(
                            title: "Coolant Temperature",
                            symbol: "T_c",
                            unit: "K",
                            placeholder: "Example: 300",
                            text: $coolantInput
                        )

                        EngineeringInputField(
                            title: "Heat-Removal Number",
                            symbol: "H",
                            unit: "—",
                            placeholder: "Example: 0",
                            text: $removalInput
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
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Find Steady States",
                            systemImage:
                                "point.3.filled.connected.trianglepath.dotted",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Steady-State Count",
                                            value:
                                                "\(result.steadyStateCount)",
                                            unit: "states"
                                        ),
                                        .init(
                                            label:
                                                "Lowest-State Temperature",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .lowestTemperatureState
                                                        .temperature
                                                ),
                                            unit: "K"
                                        ),
                                        .init(
                                            label:
                                                "Lowest-State Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .lowestTemperatureState
                                                        .conversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Middle-State Temperature",
                                            value:
                                                result.middleTemperatureState
                                                .map {
                                                    numberFormatter.format(
                                                        $0.temperature
                                                    )
                                                }
                                                ?? "—",
                                            unit: "K"
                                        ),
                                        .init(
                                            label:
                                                "Middle-State Conversion",
                                            value:
                                                result.middleTemperatureState
                                                .map {
                                                    numberFormatter.format(
                                                        100 * $0.conversion
                                                    )
                                                }
                                                ?? "—",
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Highest-State Temperature",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .highestTemperatureState
                                                        .temperature
                                                ),
                                            unit: "K"
                                        ),
                                        .init(
                                            label:
                                                "Highest-State Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .highestTemperatureState
                                                        .conversion
                                                ),
                                            unit: "%"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(
                                            result.multiplicityDescription
                                        )
                                        .font(.headline)

                                        Divider()

                                        Text(result.modelName)

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
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("CSTR Steady States")
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
                            fieldName: "inlet concentration A"
                        ),
                    spaceTime:
                        try InputValidator.parseNumber(
                            spaceTimeInput,
                            fieldName: "space time"
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
                            removalInput,
                            fieldName: "heat-removal number"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "100"
        spaceTimeInput = "1"
        factorInput = "1000000"
        activationInput = "50000"
        inletTemperatureInput = "330"
        adiabaticRiseInput = "200"
        coolantInput = "300"
        removalInput = "0"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        spaceTimeInput = ""
        factorInput = ""
        activationInput = ""
        inletTemperatureInput = ""
        adiabaticRiseInput = ""
        coolantInput = ""
        removalInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        NonIsothermalCSTRSteadyStatesView()
    }
}
