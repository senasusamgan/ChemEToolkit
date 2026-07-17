import SwiftUI

struct EnthalpyChangeCalculatorView:
    View {

    @State private var massInput = "2"
    @State private var cpInput = "4.18"
    @State private var initialTemperatureInput = "20"
    @State private var finalTemperatureInput = "80"

    @State private var result:
        EnthalpyChangeCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        EnthalpyChangeCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "thermometer.sun.fill",
                    title: "Enthalpy Change",
                    subtitle: "Calculate constant-Cp specific and total ΔH",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Temperature differences are identical in kelvin and degrees Celsius.")
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
                            title: "Specific Heat, Cp",
                            symbol: "Cp",
                            unit: "kJ/(kg·K)",
                            placeholder: "4.18",
                            text: $cpInput
                        )

                        EngineeringInputField(
                            title: "Initial Temperature",
                            symbol: "T₁",
                            unit: "°C or K",
                            placeholder: "20",
                            text: $initialTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Final Temperature",
                            symbol: "T₂",
                            unit: "same scale",
                            placeholder: "80",
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
                            systemImage: "thermometer.sun.fill",
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
                                        label: "Specific Enthalpy Change",
                                        value: numberFormatter.format(result.specificEnthalpyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Total Enthalpy Change",
                                        value: numberFormatter.format(result.totalEnthalpyChange),
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
        .navigationTitle("Enthalpy Change")
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
                    specificHeatAtConstantPressure:
                        try InputValidator.parseNumber(
                            cpInput,
                            fieldName:
                                "specific heat Cp"
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
        cpInput = "4.18"
        initialTemperatureInput = "20"
        finalTemperatureInput = "80"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        cpInput = ""
        initialTemperatureInput = ""
        finalTemperatureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EnthalpyChangeCalculatorView()
    }
}
