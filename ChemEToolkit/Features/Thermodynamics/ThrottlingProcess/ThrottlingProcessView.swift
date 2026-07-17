import SwiftUI

struct ThrottlingProcessView: View {
    @State private var temperatureInput = "300"
    @State private var inletPressureInput = "1000"
    @State private var outletPressureInput = "200"
    @State private var coefficientInput = "0.00025"
    @State private var result: ThrottlingProcessResult?
    @State private var errorMessage = ""

    private let engine = ThrottlingProcessEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "valve.open.fill",
                    title: "Throttling Process",
                    subtitle: "Estimate pressure-drop temperature change at constant enthalpy",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The Joule–Thomson coefficient is treated as constant over the pressure drop.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Inlet Temperature",
                            symbol: "T₁",
                            unit: "K",
                            placeholder: "300",
                            text: $temperatureInput
                        )

                        EngineeringInputField(
                            title: "Inlet Absolute Pressure",
                            symbol: "P₁",
                            unit: "kPa abs",
                            placeholder: "1000",
                            text: $inletPressureInput
                        )

                        EngineeringInputField(
                            title: "Outlet Absolute Pressure",
                            symbol: "P₂",
                            unit: "kPa abs",
                            placeholder: "200",
                            text: $outletPressureInput
                        )

                        EngineeringInputField(
                            title: "Joule–Thomson Coefficient",
                            symbol: "μJT",
                            unit: "K/kPa",
                            placeholder: "0.00025",
                            text: $coefficientInput
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
                            systemImage: "valve.open.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Pressure Drop",
                                        value: numberFormatter.format(result.pressureDrop),
                                        unit: "kPa"
                                    ),
.init(
                                        label: "Temperature Change",
                                        value: numberFormatter.format(result.temperatureChange),
                                        unit: "K"
                                    ),
.init(
                                        label: "Outlet Temperature",
                                        value: numberFormatter.format(result.outletTemperatureKelvin),
                                        unit: "K"
                                    ),
.init(
                                        label: "Enthalpy Change",
                                        value: numberFormatter.format(result.enthalpyChange),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Trend",
                                        value: result.trendDescription,
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
        .navigationTitle("Throttling Process")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    inletTemperatureKelvin:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName: "inlet temperature"
                        ),
                    inletAbsolutePressure:
                        try InputValidator.parseNumber(
                            inletPressureInput,
                            fieldName: "inlet absolute pressure"
                        ),
                    outletAbsolutePressure:
                        try InputValidator.parseNumber(
                            outletPressureInput,
                            fieldName: "outlet absolute pressure"
                        ),
                    jouleThomsonCoefficient:
                        try InputValidator.parseNumber(
                            coefficientInput,
                            fieldName: "joule–thomson coefficient"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        temperatureInput = "300"
        inletPressureInput = "1000"
        outletPressureInput = "200"
        coefficientInput = "0.00025"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        temperatureInput = ""
        inletPressureInput = ""
        outletPressureInput = ""
        coefficientInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { ThrottlingProcessView() } }
