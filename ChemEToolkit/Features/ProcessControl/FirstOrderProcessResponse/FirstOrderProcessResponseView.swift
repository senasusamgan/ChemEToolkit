import SwiftUI

struct FirstOrderProcessResponseView:
    View {

    @State private var initialOutputInput = "20"
    @State private var gainInput = "2"
    @State private var stepInput = "5"
    @State private var timeConstantInput = "4"
    @State private var evaluationTimeInput = "6"

    @State private var result:
        FirstOrderProcessResponseResult?

    @State private var errorMessage = ""

    private let engine =
        FirstOrderProcessResponseEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.line.uptrend.xyaxis",
                    title: "First-Order Process",
                    subtitle: "Calculate the dynamic response, time constant and settling behavior",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("A first-order process completes 63.2% of its final change after one time constant.")
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
                            systemImage: "chart.line.uptrend.xyaxis",
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
                                        label: "Response Completed",
                                        value: numberFormatter.format(100 * result.fractionOfFinalChange),
                                        unit: "%"
                                    ),
.init(
                                        label: "Initial Response Slope",
                                        value: numberFormatter.format(result.initialResponseSlope),
                                        unit: "output/time"
                                    ),
.init(
                                        label: "Half-Response Time",
                                        value: numberFormatter.format(result.halfResponseTime),
                                        unit: "time"
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
        .navigationTitle("First-Order Process")
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
        evaluationTimeInput = "6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialOutputInput = ""
        gainInput = ""
        stepInput = ""
        timeConstantInput = ""
        evaluationTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FirstOrderProcessResponseView()
    }
}
