import SwiftUI

struct IntegratingProcessResponseView:
    View {

    @State private var initialOutputInput = "10"
    @State private var gainInput = "0.5"
    @State private var stepInput = "4"
    @State private var deadTimeInput = "2"
    @State private var evaluationTimeInput = "7"
    @State private var targetOutputInput = "30"

    @State private var result:
        IntegratingProcessResponseResult?

    @State private var errorMessage = ""

    private let engine =
        IntegratingProcessResponseEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.right",
                    title: "Integrating Process",
                    subtitle: "Calculate ramp response, dead-time behavior and target reach time",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("An integrating process has no finite steady state under a sustained nonzero input step.")
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
                            placeholder: "10",
                            text: $initialOutputInput
                        )

                        EngineeringInputField(
                            title: "Integrating Gain",
                            symbol: "Kᵢ",
                            unit: "output/(input·time)",
                            placeholder: "0.5",
                            text: $gainInput
                        )

                        EngineeringInputField(
                            title: "Input Step Change",
                            symbol: "Δu",
                            unit: "input units",
                            placeholder: "4",
                            text: $stepInput
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
                            placeholder: "7",
                            text: $evaluationTimeInput
                        )

                        EngineeringInputField(
                            title: "Target Output",
                            symbol: "y_target",
                            unit: "output units",
                            placeholder: "30",
                            text: $targetOutputInput
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
                            systemImage: "arrow.up.right",
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
                                        label: "Output Rate of Change",
                                        value: numberFormatter.format(result.outputRateOfChange),
                                        unit: "output/time"
                                    ),
.init(
                                        label: "Active Integration Time",
                                        value: numberFormatter.format(result.activeIntegrationTime),
                                        unit: "time"
                                    ),
.init(
                                        label: "Target Reachable",
                                        value: result.targetIsReachable ? "Yes" : "No",
                                        unit: "—"
                                    ),
.init(
                                        label: "Target Reach Time",
                                        value: result.targetReachTime.map { numberFormatter.format($0) } ?? "Unreachable",
                                        unit: "time"
                                    ),
.init(
                                        label: "Time Remaining",
                                        value: result.timeRemainingToTarget.map { numberFormatter.format($0) } ?? "Unreachable",
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
        .navigationTitle("Integrating Process")
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
                    integratingGain: try InputValidator.parseNumber(
                        gainInput,
                        fieldName: "integrating gain"
                    ),
                    inputStepChange: try InputValidator.parseNumber(
                        stepInput,
                        fieldName: "input step change"
                    ),
                    deadTime: try InputValidator.parseNumber(
                        deadTimeInput,
                        fieldName: "dead time"
                    ),
                    evaluationTime: try InputValidator.parseNumber(
                        evaluationTimeInput,
                        fieldName: "evaluation time"
                    ),
                    targetOutput: try InputValidator.parseNumber(
                        targetOutputInput,
                        fieldName: "target output"
                    )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialOutputInput = "10"
        gainInput = "0.5"
        stepInput = "4"
        deadTimeInput = "2"
        evaluationTimeInput = "7"
        targetOutputInput = "30"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialOutputInput = ""
        gainInput = ""
        stepInput = ""
        deadTimeInput = ""
        evaluationTimeInput = ""
        targetOutputInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IntegratingProcessResponseView()
    }
}
