import SwiftUI

struct BLEVEFireballScreeningView:
    View {

    @State private var massInput = "10000"
    @State private var heatInput = "46000000"
    @State private var radiantFractionInput = "0.3"
    @State private var transmissivityInput = "0.9"
    @State private var distanceInput = "200"

    @State private var result:
        BLEVEFireballScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        BLEVEFireballScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "burst.fill",
                    title: "BLEVE Fireball Screening",
                    subtitle: "Estimate empirical fireball size, duration and radiation",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The module estimates fireball diameter and duration from flammable inventory, then screens receptor heat flux.")
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
                            title: "Flammable Mass",
                            symbol: "M",
                            unit: "kg",
                            placeholder: "10000",
                            text: $massInput
                        )

                        EngineeringInputField(
                            title: "Heat of Combustion",
                            symbol: "ΔH_c",
                            unit: "J/kg",
                            placeholder: "46000000",
                            text: $heatInput
                        )

                        EngineeringInputField(
                            title: "Radiant Fraction",
                            symbol: "χ_r",
                            unit: "—",
                            placeholder: "0.3",
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
                            placeholder: "200",
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
                            systemImage: "burst.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Fireball Diameter",
                                        value: numberFormatter.format(result.fireballDiameter),
                                        unit: "m"
                                    ),
.init(
                                        label: "Fireball Duration",
                                        value: numberFormatter.format(result.fireballDuration),
                                        unit: "s"
                                    ),
.init(
                                        label: "Combustion Energy",
                                        value: numberFormatter.format(result.totalCombustionEnergy / 1_000_000_000),
                                        unit: "GJ"
                                    ),
.init(
                                        label: "Radiated Energy",
                                        value: numberFormatter.format(result.radiatedEnergy / 1_000_000_000),
                                        unit: "GJ"
                                    ),
.init(
                                        label: "Average Radiation Flux",
                                        value: numberFormatter.format(result.averageRadiationFlux / 1_000),
                                        unit: "kW/m²"
                                    ),
.init(
                                        label: "Hazard Band",
                                        value: result.hazardBand,
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
        .navigationTitle("BLEVE Fireball Screening")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    flammableMass:
                        try InputValidator.parseNumber(
                            massInput,
                            fieldName:
                                "flammable mass"
                        ),
                    heatOfCombustion:
                        try InputValidator.parseNumber(
                            heatInput,
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
        massInput = "10000"
        heatInput = "46000000"
        radiantFractionInput = "0.3"
        transmissivityInput = "0.9"
        distanceInput = "200"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        heatInput = ""
        radiantFractionInput = ""
        transmissivityInput = ""
        distanceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BLEVEFireballScreeningView()
    }
}
