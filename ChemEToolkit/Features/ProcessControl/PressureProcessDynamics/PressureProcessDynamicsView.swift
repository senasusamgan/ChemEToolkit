import SwiftUI

struct PressureProcessDynamicsView: View {
    @State private var volumeInput = "1"
    @State private var temperatureInput = "300"
    @State private var resistanceInput = "50000"
    @State private var initialPressureInput = "100000"
    @State private var flowStepInput = "0.5"
    @State private var timeInput = "10"
    @State private var maximumPressureInput = "150000"

    @State private var result: PressureProcessDynamicsResult?
    @State private var errorMessage = ""

    private let engine = PressureProcessDynamicsEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "gauge.with.dots.needle.67percent",
                    title: "Pressure-Process Dynamics",
                    subtitle: "Calculate ideal-gas vessel pressure response and overpressure risk",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The pressure-process time constant equals gas capacitance multiplied by pressure-flow resistance.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Vessel Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "1",
                            text: $volumeInput
                        )

                        EngineeringInputField(
                            title: "Gas Temperature",
                            symbol: "T",
                            unit: "K",
                            placeholder: "300",
                            text: $temperatureInput
                        )

                        EngineeringInputField(
                            title: "Pressure-Flow Resistance",
                            symbol: "Rₚ",
                            unit: "Pa·s/mol",
                            placeholder: "50000",
                            text: $resistanceInput
                        )

                        EngineeringInputField(
                            title: "Initial Pressure",
                            symbol: "P₀",
                            unit: "Pa",
                            placeholder: "100000",
                            text: $initialPressureInput
                        )

                        EngineeringInputField(
                            title: "Molar Inflow Step",
                            symbol: "Δṅ",
                            unit: "mol/s",
                            placeholder: "0.5",
                            text: $flowStepInput
                        )

                        EngineeringInputField(
                            title: "Evaluation Time",
                            symbol: "t",
                            unit: "s",
                            placeholder: "10",
                            text: $timeInput
                        )

                        EngineeringInputField(
                            title: "Maximum Allowable Pressure",
                            symbol: "P_max",
                            unit: "Pa",
                            placeholder: "150000",
                            text: $maximumPressureInput
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
                            systemImage: "gauge.with.dots.needle.67percent",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Pressure",
                                        value: numberFormatter.format(result.pressureAtEvaluationTime),
                                        unit: "Pa"
                                    ),
.init(
                                        label: "Final Steady Pressure",
                                        value: numberFormatter.format(result.finalSteadyPressure),
                                        unit: "Pa"
                                    ),
.init(
                                        label: "Time Constant",
                                        value: numberFormatter.format(result.processTimeConstant),
                                        unit: "s"
                                    ),
.init(
                                        label: "Gas Capacitance",
                                        value: numberFormatter.format(result.gasCapacitance),
                                        unit: "mol/Pa"
                                    ),
.init(
                                        label: "Initial Pressure Rate",
                                        value: numberFormatter.format(result.initialPressureRate),
                                        unit: "Pa/s"
                                    ),
.init(
                                        label: "Overpressure Risk",
                                        value: result.overpressureRisk ? "Yes" : "No",
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName)
                                        .font(.headline)

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
        .navigationTitle("Pressure-Process Dynamics")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    vesselVolume: try InputValidator.parseNumber(
                        volumeInput,
                        fieldName: "vessel volume"
                    ),
                    gasTemperature: try InputValidator.parseNumber(
                        temperatureInput,
                        fieldName: "gas temperature"
                    ),
                    pressureFlowResistance: try InputValidator.parseNumber(
                        resistanceInput,
                        fieldName: "pressure-flow resistance"
                    ),
                    initialPressure: try InputValidator.parseNumber(
                        initialPressureInput,
                        fieldName: "initial pressure"
                    ),
                    molarInflowStepChange: try InputValidator.parseNumber(
                        flowStepInput,
                        fieldName: "molar inflow step"
                    ),
                    evaluationTime: try InputValidator.parseNumber(
                        timeInput,
                        fieldName: "evaluation time"
                    ),
                    maximumAllowablePressure: try InputValidator.parseNumber(
                        maximumPressureInput,
                        fieldName: "maximum allowable pressure"
                    )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        volumeInput = "1"
        temperatureInput = "300"
        resistanceInput = "50000"
        initialPressureInput = "100000"
        flowStepInput = "0.5"
        timeInput = "10"
        maximumPressureInput = "150000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        volumeInput = ""
        temperatureInput = ""
        resistanceInput = ""
        initialPressureInput = ""
        flowStepInput = ""
        timeInput = ""
        maximumPressureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PressureProcessDynamicsView()
    }
}
