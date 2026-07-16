import SwiftUI

struct TemperatureProcessDynamicsView:
    View {

    @State private var volumeInput = "2"
    @State private var densityInput = "1000"
    @State private var heatCapacityInput = "4180"
    @State private var flowInput = "0.01"
    @State private var conductanceInput = "200"
    @State private var inletTemperatureInput = "350"
    @State private var environmentTemperatureInput = "300"
    @State private var initialTemperatureInput = "310"
    @State private var timeInput = "100"

    @State private var result:
        TemperatureProcessDynamicsResult?

    @State private var errorMessage = ""

    private let engine =
        TemperatureProcessDynamicsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "thermometer.medium",
                    title: "Temperature-Process Dynamics",
                    subtitle: "Calculate a well-mixed thermal process response with flow and heat exchange",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The final temperature is a conductance-weighted average of inlet and environmental temperatures.")
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
                            title: "Liquid Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "2",
                            text: $volumeInput
                        )

                        EngineeringInputField(
                            title: "Liquid Density",
                            symbol: "ρ",
                            unit: "kg/m³",
                            placeholder: "1000",
                            text: $densityInput
                        )

                        EngineeringInputField(
                            title: "Specific Heat Capacity",
                            symbol: "Cₚ",
                            unit: "J/(kg·K)",
                            placeholder: "4180",
                            text: $heatCapacityInput
                        )

                        EngineeringInputField(
                            title: "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/s",
                            placeholder: "0.01",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Heat-Transfer Conductance",
                            symbol: "UA",
                            unit: "W/K",
                            placeholder: "200",
                            text: $conductanceInput
                        )

                        EngineeringInputField(
                            title: "Inlet Temperature",
                            symbol: "T_in",
                            unit: "K",
                            placeholder: "350",
                            text: $inletTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Environment Temperature",
                            symbol: "T_env",
                            unit: "K",
                            placeholder: "300",
                            text: $environmentTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Initial Temperature",
                            symbol: "T₀",
                            unit: "K",
                            placeholder: "310",
                            text: $initialTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Evaluation Time",
                            symbol: "t",
                            unit: "s",
                            placeholder: "100",
                            text: $timeInput
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
                            title: "Calculate Response",
                            systemImage: "thermometer.medium",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Temperature",
                                        value: numberFormatter.format(result.temperatureAtEvaluationTime),
                                        unit: "K"
                                    ),
.init(
                                        label: "Final Steady Temperature",
                                        value: numberFormatter.format(result.finalSteadyTemperature),
                                        unit: "K"
                                    ),
.init(
                                        label: "Process Time Constant",
                                        value: numberFormatter.format(result.processTimeConstant),
                                        unit: "s"
                                    ),
.init(
                                        label: "Flow Heat-Capacity Rate",
                                        value: numberFormatter.format(result.flowHeatCapacityRate),
                                        unit: "W/K"
                                    ),
.init(
                                        label: "Net Heat Rate",
                                        value: numberFormatter.format(result.netHeatRateAtEvaluation),
                                        unit: "W"
                                    ),
.init(
                                        label: "Response Completed",
                                        value: numberFormatter.format(100 * result.fractionOfFinalChange),
                                        unit: "%"
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
        .navigationTitle("Temperature-Process Dynamics")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    liquidVolume:
                        try InputValidator.parseNumber(
                            volumeInput,
                            fieldName:
                                "liquid volume"
                        ),
                    liquidDensity:
                        try InputValidator.parseNumber(
                            densityInput,
                            fieldName:
                                "liquid density"
                        ),
                    specificHeatCapacity:
                        try InputValidator.parseNumber(
                            heatCapacityInput,
                            fieldName:
                                "specific heat capacity"
                        ),
                    volumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "volumetric flow rate"
                        ),
                    overallHeatTransferConductance:
                        try InputValidator.parseNumber(
                            conductanceInput,
                            fieldName:
                                "heat-transfer conductance"
                        ),
                    inletTemperature:
                        try InputValidator.parseNumber(
                            inletTemperatureInput,
                            fieldName:
                                "inlet temperature"
                        ),
                    environmentTemperature:
                        try InputValidator.parseNumber(
                            environmentTemperatureInput,
                            fieldName:
                                "environment temperature"
                        ),
                    initialTemperature:
                        try InputValidator.parseNumber(
                            initialTemperatureInput,
                            fieldName:
                                "initial temperature"
                        ),
                    evaluationTime:
                        try InputValidator.parseNumber(
                            timeInput,
                            fieldName:
                                "evaluation time"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        volumeInput = "2"
        densityInput = "1000"
        heatCapacityInput = "4180"
        flowInput = "0.01"
        conductanceInput = "200"
        inletTemperatureInput = "350"
        environmentTemperatureInput = "300"
        initialTemperatureInput = "310"
        timeInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        volumeInput = ""
        densityInput = ""
        heatCapacityInput = ""
        flowInput = ""
        conductanceInput = ""
        inletTemperatureInput = ""
        environmentTemperatureInput = ""
        initialTemperatureInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        TemperatureProcessDynamicsView()
    }
}
