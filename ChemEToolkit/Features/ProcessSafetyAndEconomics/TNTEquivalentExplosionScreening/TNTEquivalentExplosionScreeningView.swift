import SwiftUI

struct TNTEquivalentExplosionScreeningView:
    View {

    @State private var massInput = "1000"
    @State private var heatInput = "46000000"
    @State private var efficiencyInput = "0.1"
    @State private var distanceInput = "100"

    @State private var result:
        TNTEquivalentExplosionScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        TNTEquivalentExplosionScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "aqi.medium",
                    title: "TNT Equivalent Explosion",
                    subtitle: "Convert explosion energy to TNT mass and scaled distance",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The screening model applies an explosion efficiency to available combustion energy, then calculates TNT equivalence.")
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
                            symbol: "M_f",
                            unit: "kg",
                            placeholder: "1000",
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
                            title: "Explosion Efficiency",
                            symbol: "η",
                            unit: "—",
                            placeholder: "0.1",
                            text: $efficiencyInput
                        )

                        EngineeringInputField(
                            title: "Receptor Distance",
                            symbol: "R",
                            unit: "m",
                            placeholder: "100",
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
                            systemImage: "aqi.medium",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Available Combustion Energy",
                                        value: numberFormatter.format(result.availableCombustionEnergy / 1_000_000_000),
                                        unit: "GJ"
                                    ),
.init(
                                        label: "Explosion Energy",
                                        value: numberFormatter.format(result.explosionEnergy / 1_000_000_000),
                                        unit: "GJ"
                                    ),
.init(
                                        label: "TNT Equivalent Mass",
                                        value: numberFormatter.format(result.tntEquivalentMass),
                                        unit: "kg TNT"
                                    ),
.init(
                                        label: "Scaled Distance",
                                        value: numberFormatter.format(result.cubeRootScaledDistance),
                                        unit: "m/kg^(1/3)"
                                    ),
.init(
                                        label: "Inverse Scaled Distance",
                                        value: numberFormatter.format(result.inverseScaledDistance),
                                        unit: "kg^(1/3)/m"
                                    ),
.init(
                                        label: "Proximity Band",
                                        value: result.proximityBand,
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
        .navigationTitle("TNT Equivalent Explosion")
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
                    explosionEfficiency:
                        try InputValidator.parseNumber(
                            efficiencyInput,
                            fieldName:
                                "explosion efficiency"
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
        massInput = "1000"
        heatInput = "46000000"
        efficiencyInput = "0.1"
        distanceInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        heatInput = ""
        efficiencyInput = ""
        distanceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        TNTEquivalentExplosionScreeningView()
    }
}
