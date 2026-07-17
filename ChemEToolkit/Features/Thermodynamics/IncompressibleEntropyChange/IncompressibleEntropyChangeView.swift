import SwiftUI

struct IncompressibleEntropyChangeView:
    View {

    @State private var massInput = "10"
    @State private var heatCapacityInput = "4.18"
    @State private var initialTemperatureInput = "300"
    @State private var finalTemperatureInput = "350"

    @State private var result:
        IncompressibleEntropyChangeResult?

    @State private var errorMessage = ""

    private let engine =
        IncompressibleEntropyChangeEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.degreesign.fill",
                    title: "Incompressible Entropy Change",
                    subtitle: "Calculate liquid or solid entropy change from temperature",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use absolute temperature in kelvin. Pressure effects are neglected.")
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
                            title: "Mass",
                            symbol: "m",
                            unit: "kg",
                            placeholder: "10",
                            text: $massInput
                        )

                        EngineeringInputField(
                            title: "Specific Heat Capacity",
                            symbol: "c",
                            unit: "kJ/(kg·K)",
                            placeholder: "4.18",
                            text: $heatCapacityInput
                        )

                        EngineeringInputField(
                            title: "Initial Temperature",
                            symbol: "T₁",
                            unit: "K",
                            placeholder: "300",
                            text: $initialTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Final Temperature",
                            symbol: "T₂",
                            unit: "K",
                            placeholder: "350",
                            text: $finalTemperatureInput
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
                            systemImage: "drop.degreesign.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Temperature Ratio, T₂/T₁",
                                        value: numberFormatter.format(result.temperatureRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Specific Entropy Change",
                                        value: numberFormatter.format(result.specificEntropyChange),
                                        unit: "kJ/(kg·K)"
                                    ),
.init(
                                        label: "Total Entropy Change",
                                        value: numberFormatter.format(result.totalEntropyChange),
                                        unit: "kJ/K"
                                    ),
.init(
                                        label: "Direction",
                                        value: result.directionDescription,
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
        .navigationTitle("Incompressible Entropy Change")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    mass:
                        try InputValidator.parseNumber(
                            massInput,
                            fieldName: "mass"
                        ),
                    specificHeatCapacity:
                        try InputValidator.parseNumber(
                            heatCapacityInput,
                            fieldName:
                                "specific heat capacity"
                        ),
                    initialTemperatureKelvin:
                        try InputValidator.parseNumber(
                            initialTemperatureInput,
                            fieldName:
                                "initial temperature"
                        ),
                    finalTemperatureKelvin:
                        try InputValidator.parseNumber(
                            finalTemperatureInput,
                            fieldName:
                                "final temperature"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massInput = "10"
        heatCapacityInput = "4.18"
        initialTemperatureInput = "300"
        finalTemperatureInput = "350"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        heatCapacityInput = ""
        initialTemperatureInput = ""
        finalTemperatureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IncompressibleEntropyChangeView()
    }
}
