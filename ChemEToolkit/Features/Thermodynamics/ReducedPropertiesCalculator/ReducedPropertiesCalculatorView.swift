import SwiftUI

struct ReducedPropertiesCalculatorView:
    View {

    @State private var temperatureInput = "350"
    @State private var criticalTemperatureInput = "304.13"
    @State private var pressureInput = "5000"
    @State private var criticalPressureInput = "7377"

    @State private var result:
        ReducedPropertiesCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        ReducedPropertiesCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Reduced Properties",
                    subtitle: "Normalize temperature and pressure by critical values",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use absolute pressure and kelvin. Actual and critical pressures must use the same unit.")
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
                            title: "Temperature",
                            symbol: "T",
                            unit: "K",
                            placeholder: "350",
                            text: $temperatureInput
                        )

                        EngineeringInputField(
                            title: "Critical Temperature",
                            symbol: "T_c",
                            unit: "K",
                            placeholder: "304.13",
                            text: $criticalTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Absolute Pressure",
                            symbol: "P",
                            unit: "kPa abs",
                            placeholder: "5000",
                            text: $pressureInput
                        )

                        EngineeringInputField(
                            title: "Critical Pressure",
                            symbol: "P_c",
                            unit: "kPa abs",
                            placeholder: "7377",
                            text: $criticalPressureInput
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
                            systemImage: "scope",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Reduced Temperature",
                                        value: numberFormatter.format(result.reducedTemperature),
                                        unit: "—"
                                    ),
.init(
                                        label: "Reduced Pressure",
                                        value: numberFormatter.format(result.reducedPressure),
                                        unit: "—"
                                    ),
.init(
                                        label: "Tᵣ − 1",
                                        value: numberFormatter.format(result.temperatureDistanceFromCritical),
                                        unit: "—"
                                    ),
.init(
                                        label: "Pᵣ − 1",
                                        value: numberFormatter.format(result.pressureDistanceFromCritical),
                                        unit: "—"
                                    ),
.init(
                                        label: "Relative Region",
                                        value: result.regionDescription,
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
        .navigationTitle("Reduced Properties")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    temperatureKelvin:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName:
                                "temperature"
                        ),
                    criticalTemperatureKelvin:
                        try InputValidator.parseNumber(
                            criticalTemperatureInput,
                            fieldName:
                                "critical temperature"
                        ),
                    absolutePressure:
                        try InputValidator.parseNumber(
                            pressureInput,
                            fieldName:
                                "absolute pressure"
                        ),
                    criticalPressure:
                        try InputValidator.parseNumber(
                            criticalPressureInput,
                            fieldName:
                                "critical pressure"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        temperatureInput = "350"
        criticalTemperatureInput = "304.13"
        pressureInput = "5000"
        criticalPressureInput = "7377"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        temperatureInput = ""
        criticalTemperatureInput = ""
        pressureInput = ""
        criticalPressureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReducedPropertiesCalculatorView()
    }
}
