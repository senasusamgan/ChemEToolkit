import SwiftUI

struct OpenLoopResponseView: View {
    @State private var initialOutputInput = "20"
    @State private var biasInput = "50"
    @State private var controllerGainInput = "2"
    @State private var referenceStepInput = "10"
    @State private var minimumInput = "0"
    @State private var maximumInput = "100"
    @State private var processGainInput = "0.5"
    @State private var timeConstantInput = "4"
    @State private var deadTimeInput = "2"
    @State private var timeInput = "6"

    @State private var result: OpenLoopResponseResult?
    @State private var errorMessage = ""

    private let engine = OpenLoopResponseEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.right",
                    title: "Open-Loop Response",
                    subtitle: "Evaluate controller action and process response without feedback correction",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Open-loop control does not measure the process output, so it cannot automatically reject disturbances or model mismatch.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Initial Process Output",
                            symbol: "y₀",
                            unit: "output units",
                            placeholder: "20",
                            text: $initialOutputInput
                        )

                        EngineeringInputField(
                            title: "Controller Bias",
                            symbol: "u_bias",
                            unit: "%",
                            placeholder: "50",
                            text: $biasInput
                        )

                        EngineeringInputField(
                            title: "Controller Gain",
                            symbol: "K_c",
                            unit: "%/input",
                            placeholder: "2",
                            text: $controllerGainInput
                        )

                        EngineeringInputField(
                            title: "Reference Step",
                            symbol: "Δr",
                            unit: "input units",
                            placeholder: "10",
                            text: $referenceStepInput
                        )

                        EngineeringInputField(
                            title: "Minimum Controller Output",
                            symbol: "u_min",
                            unit: "%",
                            placeholder: "0",
                            text: $minimumInput
                        )

                        EngineeringInputField(
                            title: "Maximum Controller Output",
                            symbol: "u_max",
                            unit: "%",
                            placeholder: "100",
                            text: $maximumInput
                        )

                        EngineeringInputField(
                            title: "Process Gain",
                            symbol: "K_p",
                            unit: "output/%",
                            placeholder: "0.5",
                            text: $processGainInput
                        )

                        EngineeringInputField(
                            title: "Process Time Constant",
                            symbol: "τ",
                            unit: "time",
                            placeholder: "4",
                            text: $timeConstantInput
                        )

                        EngineeringInputField(
                            title: "Process Dead Time",
                            symbol: "θ",
                            unit: "time",
                            placeholder: "2",
                            text: $deadTimeInput
                        )

                        EngineeringInputField(
                            title: "Evaluation Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "6",
                            text: $timeInput
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
                            systemImage: "arrow.right",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Requested Controller Output",
                                        value: numberFormatter.format(result.requestedControllerOutput),
                                        unit: "%"
                                    ),
.init(
                                        label: "Applied Controller Output",
                                        value: numberFormatter.format(result.appliedControllerOutput),
                                        unit: "%"
                                    ),
.init(
                                        label: "Open-Loop Gain",
                                        value: numberFormatter.format(result.openLoopGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Process Output",
                                        value: numberFormatter.format(result.processOutputAtEvaluationTime),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Final Process Output",
                                        value: numberFormatter.format(result.finalProcessOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Controller Saturated",
                                        value: result.controllerIsSaturated ? "Yes" : "No",
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
        .navigationTitle("Open-Loop Response")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialProcessOutput: try InputValidator.parseNumber(
                        initialOutputInput,
                        fieldName: "initial process output"
                    ),
                    controllerBias: try InputValidator.parseNumber(
                        biasInput,
                        fieldName: "controller bias"
                    ),
                    controllerGain: try InputValidator.parseNumber(
                        controllerGainInput,
                        fieldName: "controller gain"
                    ),
                    referenceStepChange: try InputValidator.parseNumber(
                        referenceStepInput,
                        fieldName: "reference step"
                    ),
                    minimumControllerOutput: try InputValidator.parseNumber(
                        minimumInput,
                        fieldName: "minimum controller output"
                    ),
                    maximumControllerOutput: try InputValidator.parseNumber(
                        maximumInput,
                        fieldName: "maximum controller output"
                    ),
                    processGain: try InputValidator.parseNumber(
                        processGainInput,
                        fieldName: "process gain"
                    ),
                    processTimeConstant: try InputValidator.parseNumber(
                        timeConstantInput,
                        fieldName: "process time constant"
                    ),
                    processDeadTime: try InputValidator.parseNumber(
                        deadTimeInput,
                        fieldName: "process dead time"
                    ),
                    evaluationTime: try InputValidator.parseNumber(
                        timeInput,
                        fieldName: "evaluation time"
                    )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        initialOutputInput = "20"
        biasInput = "50"
        controllerGainInput = "2"
        referenceStepInput = "10"
        minimumInput = "0"
        maximumInput = "100"
        processGainInput = "0.5"
        timeConstantInput = "4"
        deadTimeInput = "2"
        timeInput = "6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialOutputInput = ""
        biasInput = ""
        controllerGainInput = ""
        referenceStepInput = ""
        minimumInput = ""
        maximumInput = ""
        processGainInput = ""
        timeConstantInput = ""
        deadTimeInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        OpenLoopResponseView()
    }
}
