import SwiftUI

struct IdealGasEntropyChangeView:
    View {

    @State private var massInput = "1"
    @State private var cpInput = "1.005"
    @State private var gasConstantInput = "0.287"
    @State private var initialTemperatureInput = "300"
    @State private var finalTemperatureInput = "500"
    @State private var initialPressureInput = "100"
    @State private var finalPressureInput = "500"

    @State private var result:
        IdealGasEntropyChangeResult?

    @State private var errorMessage = ""

    private let engine =
        IdealGasEntropyChangeEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "waveform.path.ecg.rectangle.fill",
                    title: "Ideal-Gas Entropy Change",
                    subtitle: "Calculate entropy change from temperature and pressure ratios",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use absolute temperatures and pressures. Cp and R must use the same units.")
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
                            placeholder: "1",
                            text: $massInput
                        )

                        EngineeringInputField(
                            title: "Specific Heat, Cp",
                            symbol: "Cp",
                            unit: "kJ/(kg·K)",
                            placeholder: "1.005",
                            text: $cpInput
                        )

                        EngineeringInputField(
                            title: "Specific Gas Constant",
                            symbol: "R",
                            unit: "kJ/(kg·K)",
                            placeholder: "0.287",
                            text: $gasConstantInput
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

                        EngineeringInputField(
                            title: "Initial Absolute Pressure",
                            symbol: "P₁",
                            unit: "kPa abs",
                            placeholder: "100",
                            text: $initialPressureInput
                        )

                        EngineeringInputField(
                            title: "Final Absolute Pressure",
                            symbol: "P₂",
                            unit: "kPa abs",
                            placeholder: "500",
                            text: $finalPressureInput
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
                            systemImage: "waveform.path.ecg.rectangle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Temperature Contribution",
                                        value: numberFormatter.format(result.temperatureContribution),
                                        unit: "kJ/(kg·K)"
                                    ),
.init(
                                        label: "Pressure Contribution",
                                        value: numberFormatter.format(result.pressureContribution),
                                        unit: "kJ/(kg·K)"
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
                                        label: "Calculated Cv",
                                        value: numberFormatter.format(result.specificHeatAtConstantVolume),
                                        unit: "kJ/(kg·K)"
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
        .navigationTitle("Ideal-Gas Entropy Change")
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
                    specificGasConstant:
                        try InputValidator.parseNumber(
                            gasConstantInput,
                            fieldName:
                                "specific gas constant"
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
                        ),
                    initialAbsolutePressure:
                        try InputValidator.parseNumber(
                            initialPressureInput,
                            fieldName:
                                "initial absolute pressure"
                        ),
                    finalAbsolutePressure:
                        try InputValidator.parseNumber(
                            finalPressureInput,
                            fieldName:
                                "final absolute pressure"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massInput = "1"
        cpInput = "1.005"
        gasConstantInput = "0.287"
        initialTemperatureInput = "300"
        finalTemperatureInput = "500"
        initialPressureInput = "100"
        finalPressureInput = "500"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        cpInput = ""
        gasConstantInput = ""
        initialTemperatureInput = ""
        finalTemperatureInput = ""
        initialPressureInput = ""
        finalPressureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IdealGasEntropyChangeView()
    }
}
