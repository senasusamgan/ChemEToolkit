import SwiftUI

struct SecondOrderProcessResponseView:
    View {

    @State private var initialOutputInput = "0"
    @State private var gainInput = "1"
    @State private var stepInput = "1"
    @State private var frequencyInput = "1"
    @State private var dampingInput = "0.5"
    @State private var timeInput = "2"

    @State private var result:
        SecondOrderProcessResponseResult?

    @State private var errorMessage = ""

    private let engine =
        SecondOrderProcessResponseEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "waveform.path",
                    title: "Second-Order Process",
                    subtitle: "Evaluate underdamped, critical and overdamped process responses",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The damping ratio determines whether the process oscillates, reaches critical damping or responds overdamped.")
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
                            placeholder: "0",
                            text: $initialOutputInput
                        )

                        EngineeringInputField(
                            title: "Process Gain",
                            symbol: "K",
                            unit: "output/input",
                            placeholder: "1",
                            text: $gainInput
                        )

                        EngineeringInputField(
                            title: "Input Step Change",
                            symbol: "Δu",
                            unit: "input units",
                            placeholder: "1",
                            text: $stepInput
                        )

                        EngineeringInputField(
                            title: "Natural Frequency",
                            symbol: "ωₙ",
                            unit: "rad/time",
                            placeholder: "1",
                            text: $frequencyInput
                        )

                        EngineeringInputField(
                            title: "Damping Ratio",
                            symbol: "ζ",
                            unit: "—",
                            placeholder: "0.5",
                            text: $dampingInput
                        )

                        EngineeringInputField(
                            title: "Evaluation Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "2",
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
                            systemImage: "waveform.path",
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
                                        label: "Damping Regime",
                                        value: result.dampingRegime,
                                        unit: "—"
                                    ),
.init(
                                        label: "Percent Overshoot",
                                        value: numberFormatter.format(result.percentOvershoot),
                                        unit: "%"
                                    ),
.init(
                                        label: "Peak Time",
                                        value: result.peakTime.map { numberFormatter.format($0) } ?? "No finite peak",
                                        unit: "time"
                                    ),
.init(
                                        label: "2% Settling Time",
                                        value: numberFormatter.format(result.approximateTwoPercentSettlingTime),
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
        .navigationTitle("Second-Order Process")
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
                    naturalFrequency: try InputValidator.parseNumber(
                        frequencyInput,
                        fieldName: "natural frequency"
                    ),
                    dampingRatio: try InputValidator.parseNumber(
                        dampingInput,
                        fieldName: "damping ratio"
                    ),
                    evaluationTime: try InputValidator.parseNumber(
                        timeInput,
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
        initialOutputInput = "0"
        gainInput = "1"
        stepInput = "1"
        frequencyInput = "1"
        dampingInput = "0.5"
        timeInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialOutputInput = ""
        gainInput = ""
        stepInput = ""
        frequencyInput = ""
        dampingInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SecondOrderProcessResponseView()
    }
}
