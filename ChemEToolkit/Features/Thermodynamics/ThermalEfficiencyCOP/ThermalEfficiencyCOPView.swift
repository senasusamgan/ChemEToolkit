import SwiftUI

struct ThermalEfficiencyCOPView: View {
    @State private var highHeatInput = "1000"
    @State private var lowHeatInput = "600"
    @State private var result: ThermalEfficiencyCOPResult?
    @State private var errorMessage = ""

    private let engine = ThermalEfficiencyCOPEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.2.circlepath.circle.fill",
                    title: "Thermal Efficiency & COP",
                    subtitle: "Calculate engine efficiency, refrigerator COP and heat-pump COP",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Enter positive heat magnitudes with QH greater than QL.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "High-Temperature Heat",
                            symbol: "QH",
                            unit: "kJ or kW",
                            placeholder: "1000",
                            text: $highHeatInput
                        )

                        EngineeringInputField(
                            title: "Low-Temperature Heat",
                            symbol: "QL",
                            unit: "same unit",
                            placeholder: "600",
                            text: $lowHeatInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "arrow.triangle.2.circlepath.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Net Work",
                                        value: numberFormatter.format(result.netWork),
                                        unit: "input energy or power unit"
                                    ),
.init(
                                        label: "Heat-Engine Efficiency",
                                        value: numberFormatter.format(result.heatEngineEfficiency),
                                        unit: "—"
                                    ),
.init(
                                        label: "Refrigerator COP",
                                        value: numberFormatter.format(result.refrigeratorCOP),
                                        unit: "—"
                                    ),
.init(
                                        label: "Heat-Pump COP",
                                        value: numberFormatter.format(result.heatPumpCOP),
                                        unit: "—"
                                    ),
.init(
                                        label: "Rejected-Heat Fraction",
                                        value: numberFormatter.format(result.rejectedHeatFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Assessment",
                                        value: result.performanceDescription,
                                        unit: "—"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(message: errorMessage)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Thermal Efficiency & COP")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    highTemperatureHeat:
                        try InputValidator.parseNumber(
                            highHeatInput,
                            fieldName: "high-temperature heat"
                        ),
                    lowTemperatureHeat:
                        try InputValidator.parseNumber(
                            lowHeatInput,
                            fieldName: "low-temperature heat"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        highHeatInput = "1000"
        lowHeatInput = "600"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        highHeatInput = ""
        lowHeatInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { ThermalEfficiencyCOPView() } }
