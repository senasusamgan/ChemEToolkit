import SwiftUI

struct FirstOrderPlusDeadTimeProcessView:
    View {

    @State private var initialOutputInput = "20"
    @State private var gainInput = "2"
    @State private var stepInput = "5"
    @State private var timeConstantInput = "4"
    @State private var deadTimeInput = "2"
    @State private var evaluationTimeInput = "6"

    @State private var result:
        FirstOrderPlusDeadTimeProcessResult?

    @State private var errorMessage = ""

    private let engine =
        FirstOrderPlusDeadTimeProcessEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "clock",
                    title: "First-Order Plus Dead Time",
                    subtitle: "Evaluate an FOPDT step response with process transport delay",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Before the dead time expires, the modeled process output remains at its initial value.")
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
                            title: "Initial Output",
                            symbol: "y₀",
                            unit: "output units",
                            placeholder: "20",
                            text: $initialOutputInput
                        )

                        EngineeringInputField(
                            title: "Process Gain",
                            symbol: "K",
                            unit: "output/input",
                            placeholder: "2",
                            text: $gainInput
                        )

                        EngineeringInputField(
                            title: "Input Step Change",
                            symbol: "Δu",
                            unit: "input units",
                            placeholder: "5",
                            text: $stepInput
                        )

                        EngineeringInputField(
                            title: "Time Constant",
                            symbol: "τ",
                            unit: "time",
                            placeholder: "4",
                            text: $timeConstantInput
                        )

                        EngineeringInputField(
                            title: "Dead Time",
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
                            text: $evaluationTimeInput
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
                            systemImage: "clock",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Output at Evaluation Time",
                                        value: numberFormatter.format(result.outputAtEvaluationTime),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Final Steady-State Output",
                                        value: numberFormatter.format(result.finalSteadyStateOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Active Response Time",
                                        value: numberFormatter.format(result.activeResponseTime),
                                        unit: "time"
                                    ),
.init(
                                        label: "Response Completed",
                                        value: numberFormatter.format(100 * result.fractionOfFinalChange),
                                        unit: "%"
                                    ),
.init(
                                        label: "Dead-Time Ratio",
                                        value: numberFormatter.format(result.deadTimeToTimeConstantRatio),
                                        unit: "θ/τ"
                                    ),
.init(
                                        label: "2% Settling Time",
                                        value: numberFormatter.format(result.twoPercentSettlingTime),
                                        unit: "time"
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
        .navigationTitle("First-Order Plus Dead Time")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialOutput: try InputValidator.parseNumber(
                        initialOutputInput,
                        fieldName: "initial output"
                    ),
                    processGain: try InputValidator.parseNumber(
                        gainInput,
                        fieldName: "process gain"
                    ),
                    inputStepChange: try InputValidator.parseNumber(
                        stepInput,
                        fieldName: "input step change"
                    ),
                    timeConstant: try InputValidator.parseNumber(
                        timeConstantInput,
                        fieldName: "time constant"
                    ),
                    deadTime: try InputValidator.parseNumber(
                        deadTimeInput,
                        fieldName: "dead time"
                    ),
                    evaluationTime: try InputValidator.parseNumber(
                        evaluationTimeInput,
                        fieldName: "evaluation time"
                    )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialOutputInput = "20"
        gainInput = "2"
        stepInput = "5"
        timeConstantInput = "4"
        deadTimeInput = "2"
        evaluationTimeInput = "6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialOutputInput = ""
        gainInput = ""
        stepInput = ""
        timeConstantInput = ""
        deadTimeInput = ""
        evaluationTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FirstOrderPlusDeadTimeProcessView()
    }
}
