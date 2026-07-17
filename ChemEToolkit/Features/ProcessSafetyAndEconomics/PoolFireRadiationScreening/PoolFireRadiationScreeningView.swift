import SwiftUI

struct PoolFireRadiationScreeningView:
    View {

    @State private var massRateInput = "5"
    @State private var heatOfCombustionInput = "44000000"
    @State private var radiantFractionInput = "0.2"
    @State private var transmissivityInput = "0.9"
    @State private var distanceInput = "50"

    @State private var result:
        PoolFireRadiationScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        PoolFireRadiationScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "flame.circle.fill",
                    title: "Pool Fire Radiation",
                    subtitle: "Estimate point-source thermal radiation from a burning liquid pool",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The screening relation converts fuel burning rate into radiated heat flux at a receptor distance.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
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
                            title: "Burning Mass Rate",
                            symbol: "ṁ_b",
                            unit: "kg/s",
                            placeholder: "5",
                            text: $massRateInput
                        )

                        EngineeringInputField(
                            title: "Heat of Combustion",
                            symbol: "ΔH_c",
                            unit: "J/kg",
                            placeholder: "44000000",
                            text: $heatOfCombustionInput
                        )

                        EngineeringInputField(
                            title: "Radiant Fraction",
                            symbol: "χ_r",
                            unit: "—",
                            placeholder: "0.2",
                            text: $radiantFractionInput
                        )

                        EngineeringInputField(
                            title: "Atmospheric Transmissivity",
                            symbol: "τ_a",
                            unit: "—",
                            placeholder: "0.9",
                            text: $transmissivityInput
                        )

                        EngineeringInputField(
                            title: "Receptor Distance",
                            symbol: "R",
                            unit: "m",
                            placeholder: "50",
                            text: $distanceInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
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
                            title: "Calculate",
                            systemImage: "flame.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Total Heat Release Rate",
                                        value: numberFormatter.format(result.totalHeatReleaseRate / 1_000_000),
                                        unit: "MW"
                                    ),
.init(
                                        label: "Radiated Heat Rate",
                                        value: numberFormatter.format(result.radiatedHeatRate / 1_000_000),
                                        unit: "MW"
                                    ),
.init(
                                        label: "Transmitted Radiated Heat",
                                        value: numberFormatter.format(result.transmittedRadiatedHeatRate / 1_000_000),
                                        unit: "MW"
                                    ),
.init(
                                        label: "Thermal Radiation Flux",
                                        value: numberFormatter.format(result.thermalRadiationFlux / 1_000),
                                        unit: "kW/m²"
                                    ),
.init(
                                        label: "Hazard Band",
                                        value: result.hazardBand,
                                        unit: "—"
                                    ),
.init(
                                        label: "Assessment",
                                        value: result.screeningDescription,
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
        .navigationTitle("Pool Fire Radiation")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    burningMassRate:
                        try InputValidator.parseNumber(
                            massRateInput,
                            fieldName:
                                "burning mass rate"
                        ),
                    heatOfCombustion:
                        try InputValidator.parseNumber(
                            heatOfCombustionInput,
                            fieldName:
                                "heat of combustion"
                        ),
                    radiantFraction:
                        try InputValidator.parseNumber(
                            radiantFractionInput,
                            fieldName:
                                "radiant fraction"
                        ),
                    atmosphericTransmissivity:
                        try InputValidator.parseNumber(
                            transmissivityInput,
                            fieldName:
                                "atmospheric transmissivity"
                        ),
                    receptorDistance:
                        try InputValidator.parseNumber(
                            distanceInput,
                            fieldName:
                                "receptor distance"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massRateInput = "5"
        heatOfCombustionInput = "44000000"
        radiantFractionInput = "0.2"
        transmissivityInput = "0.9"
        distanceInput = "50"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massRateInput = ""
        heatOfCombustionInput = ""
        radiantFractionInput = ""
        transmissivityInput = ""
        distanceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PoolFireRadiationScreeningView()
    }
}
