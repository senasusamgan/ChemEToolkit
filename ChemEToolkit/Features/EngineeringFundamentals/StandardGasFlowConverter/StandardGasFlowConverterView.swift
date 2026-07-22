import SwiftUI

struct StandardGasFlowConverterView:
    View {

    @State private var flowInput = "100"
    @State private var actualPressureInput = "200000"
    @State private var actualTemperatureInput = "320"
    @State private var standardPressureInput = "101325"
    @State private var standardTemperatureInput = "273.15"

    @State private var result:
        StandardGasFlowConverterResult?

    @State private var errorMessage = ""

    private let engine =
        StandardGasFlowConverterEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind",
                    title: "Standard Gas Flow Conversion",
                    subtitle: "Convert actual gas flow to selected standard conditions",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Use absolute pressures and kelvin. The output retains the entered time basis.")
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
                            title: "Actual Volumetric Flow Rate",
                            symbol: "Q_a",
                            unit: "m³/h",
                            placeholder: "100",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Actual Absolute Pressure",
                            symbol: "P_a",
                            unit: "Pa abs",
                            placeholder: "200000",
                            text: $actualPressureInput
                        )

                        EngineeringInputField(
                            title: "Actual Temperature",
                            symbol: "T_a",
                            unit: "K",
                            placeholder: "320",
                            text: $actualTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Standard Absolute Pressure",
                            symbol: "P_s",
                            unit: "Pa abs",
                            placeholder: "101325",
                            text: $standardPressureInput
                        )

                        EngineeringInputField(
                            title: "Standard Temperature",
                            symbol: "T_s",
                            unit: "K",
                            placeholder: "273.15",
                            text: $standardTemperatureInput
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
                            systemImage: "wind",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Standard Volumetric Flow Rate",
                                        value: numberFormatter.format(result.standardVolumetricFlowRate),
                                        unit: "standard m³/h"
                                    ),
.init(
                                        label: "Standard / Actual Flow Ratio",
                                        value: numberFormatter.format(result.standardToActualFlowRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Pressure Correction Factor",
                                        value: numberFormatter.format(result.pressureCorrectionFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Temperature Correction Factor",
                                        value: numberFormatter.format(result.temperatureCorrectionFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Actual / Standard Density Ratio",
                                        value: numberFormatter.format(result.actualToStandardDensityRatio),
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Standard Gas Flow Conversion")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    actualVolumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "actual volumetric flow rate"
                        ),
                    actualAbsolutePressure:
                        try InputValidator.parseNumber(
                            actualPressureInput,
                            fieldName:
                                "actual absolute pressure"
                        ),
                    actualTemperatureKelvin:
                        try InputValidator.parseNumber(
                            actualTemperatureInput,
                            fieldName:
                                "actual temperature"
                        ),
                    standardAbsolutePressure:
                        try InputValidator.parseNumber(
                            standardPressureInput,
                            fieldName:
                                "standard absolute pressure"
                        ),
                    standardTemperatureKelvin:
                        try InputValidator.parseNumber(
                            standardTemperatureInput,
                            fieldName:
                                "standard temperature"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flowInput = "100"
        actualPressureInput = "200000"
        actualTemperatureInput = "320"
        standardPressureInput = "101325"
        standardTemperatureInput = "273.15"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flowInput = ""
        actualPressureInput = ""
        actualTemperatureInput = ""
        standardPressureInput = ""
        standardTemperatureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        StandardGasFlowConverterView()
    }
}
