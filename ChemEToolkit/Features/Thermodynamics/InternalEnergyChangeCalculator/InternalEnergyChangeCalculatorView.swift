import SwiftUI

struct InternalEnergyChangeCalculatorView:
    View {

    @State private var massInput = "2"
    @State private var cvInput = "0.718"
    @State private var initialTemperatureInput = "300"
    @State private var finalTemperatureInput = "500"

    @State private var result:
        InternalEnergyChangeCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        InternalEnergyChangeCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "bolt.horizontal.circle.fill",
                    title: "Internal-Energy Change",
                    subtitle: "Calculate constant-Cv specific and total ΔU",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use a consistent mass and specific-heat basis. Temperature differences must use kelvin or degrees Celsius.")
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
                            placeholder: "2",
                            text: $massInput
                        )

                        EngineeringInputField(
                            title: "Specific Heat, Cv",
                            symbol: "Cv",
                            unit: "kJ/(kg·K)",
                            placeholder: "0.718",
                            text: $cvInput
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
                            placeholder: "500",
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
                            systemImage: "bolt.horizontal.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Temperature Change",
                                        value: numberFormatter.format(result.temperatureChange),
                                        unit: "K"
                                    ),
.init(
                                        label: "Specific Internal-Energy Change",
                                        value: numberFormatter.format(result.specificInternalEnergyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Total Internal-Energy Change",
                                        value: numberFormatter.format(result.totalInternalEnergyChange),
                                        unit: "kJ"
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
        .navigationTitle("Internal-Energy Change")
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
                    specificHeatAtConstantVolume:
                        try InputValidator.parseNumber(
                            cvInput,
                            fieldName:
                                "specific heat Cv"
                        ),
                    initialTemperature:
                        try InputValidator.parseNumber(
                            initialTemperatureInput,
                            fieldName:
                                "initial temperature"
                        ),
                    finalTemperature:
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
        massInput = "2"
        cvInput = "0.718"
        initialTemperatureInput = "300"
        finalTemperatureInput = "500"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        cvInput = ""
        initialTemperatureInput = ""
        finalTemperatureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        InternalEnergyChangeCalculatorView()
    }
}
