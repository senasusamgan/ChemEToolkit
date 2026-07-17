import SwiftUI

struct IsothermalIdealGasProcessView:
    View {

    @State private var amountInput = "1"
    @State private var temperatureInput = "300"
    @State private var initialPressureInput = "500"
    @State private var finalPressureInput = "100"

    @State private var result:
        IsothermalIdealGasProcessResult?

    @State private var errorMessage = ""

    private let engine =
        IsothermalIdealGasProcessEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "thermometer.low",
                    title: "Isothermal Ideal-Gas Process",
                    subtitle: "Calculate reversible constant-temperature work",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Positive work means expansion work performed by the gas; compression produces negative work.")
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
                            title: "Gas Amount",
                            symbol: "n",
                            unit: "kmol",
                            placeholder: "1",
                            text: $amountInput
                        )

                        EngineeringInputField(
                            title: "Temperature",
                            symbol: "T",
                            unit: "K",
                            placeholder: "300",
                            text: $temperatureInput
                        )

                        EngineeringInputField(
                            title: "Initial Absolute Pressure",
                            symbol: "P₁",
                            unit: "kPa abs",
                            placeholder: "500",
                            text: $initialPressureInput
                        )

                        EngineeringInputField(
                            title: "Final Absolute Pressure",
                            symbol: "P₂",
                            unit: "kPa abs",
                            placeholder: "100",
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
                            systemImage: "thermometer.low",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Pressure Ratio, P₂/P₁",
                                        value: numberFormatter.format(result.pressureRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Volume Ratio, V₂/V₁",
                                        value: numberFormatter.format(result.volumeRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Work by System",
                                        value: numberFormatter.format(result.workBySystem),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Heat to System",
                                        value: numberFormatter.format(result.heatToSystem),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Internal-Energy Change",
                                        value: numberFormatter.format(result.internalEnergyChange),
                                        unit: "kJ"
                                    ),
.init(
                                        label: "Process Direction",
                                        value: result.processDirection,
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
        .navigationTitle("Isothermal Ideal-Gas Process")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    amountKilomoles:
                        try InputValidator.parseNumber(
                            amountInput,
                            fieldName:
                                "gas amount"
                        ),
                    temperatureKelvin:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName:
                                "temperature"
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
        amountInput = "1"
        temperatureInput = "300"
        initialPressureInput = "500"
        finalPressureInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        amountInput = ""
        temperatureInput = ""
        initialPressureInput = ""
        finalPressureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IsothermalIdealGasProcessView()
    }
}
