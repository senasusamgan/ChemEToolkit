import SwiftUI

struct AdiabaticIdealGasProcessView:
    View {

    @State private var temperatureInput = "500"
    @State private var initialPressureInput = "1000"
    @State private var finalPressureInput = "100"
    @State private var gammaInput = "1.4"
    @State private var gasConstantInput = "0.287"

    @State private var result:
        AdiabaticIdealGasProcessResult?

    @State private var errorMessage = ""

    private let engine =
        AdiabaticIdealGasProcessEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.right.circle.fill",
                    title: "Adiabatic Ideal-Gas Process",
                    subtitle: "Calculate reversible adiabatic temperature and work",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The model uses the ideal-gas isentropic pressure–temperature relation with constant γ.")
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
                            title: "Initial Temperature",
                            symbol: "T₁",
                            unit: "K",
                            placeholder: "500",
                            text: $temperatureInput
                        )

                        EngineeringInputField(
                            title: "Initial Absolute Pressure",
                            symbol: "P₁",
                            unit: "kPa abs",
                            placeholder: "1000",
                            text: $initialPressureInput
                        )

                        EngineeringInputField(
                            title: "Final Absolute Pressure",
                            symbol: "P₂",
                            unit: "kPa abs",
                            placeholder: "100",
                            text: $finalPressureInput
                        )

                        EngineeringInputField(
                            title: "Heat-Capacity Ratio",
                            symbol: "γ",
                            unit: "—",
                            placeholder: "1.4",
                            text: $gammaInput
                        )

                        EngineeringInputField(
                            title: "Specific Gas Constant",
                            symbol: "R",
                            unit: "kJ/(kg·K)",
                            placeholder: "0.287",
                            text: $gasConstantInput
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
                            systemImage: "arrow.up.right.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Final Temperature",
                                        value: numberFormatter.format(result.finalTemperatureKelvin),
                                        unit: "K"
                                    ),
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
                                        label: "Specific Work by System",
                                        value: numberFormatter.format(result.specificWorkBySystem),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Specific ΔU",
                                        value: numberFormatter.format(result.specificInternalEnergyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Process",
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
        .navigationTitle("Adiabatic Ideal-Gas Process")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialTemperatureKelvin:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName:
                                "initial temperature"
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
                        ),
                    heatCapacityRatio:
                        try InputValidator.parseNumber(
                            gammaInput,
                            fieldName:
                                "heat-capacity ratio"
                        ),
                    specificGasConstant:
                        try InputValidator.parseNumber(
                            gasConstantInput,
                            fieldName:
                                "specific gas constant"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        temperatureInput = "500"
        initialPressureInput = "1000"
        finalPressureInput = "100"
        gammaInput = "1.4"
        gasConstantInput = "0.287"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        temperatureInput = ""
        initialPressureInput = ""
        finalPressureInput = ""
        gammaInput = ""
        gasConstantInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AdiabaticIdealGasProcessView()
    }
}
