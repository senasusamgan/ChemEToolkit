import SwiftUI

struct SmithPredictorView:
    View {

    @State private var initialOutputInput = "20"
    @State private var stepInput = "5"
    @State private var actualGainInput = "2"
    @State private var actualTimeInput = "4"
    @State private var actualDeadInput = "3"
    @State private var modelGainInput = "1.9"
    @State private var modelTimeInput = "4.2"
    @State private var modelDeadInput = "2.8"
    @State private var timeInput = "6"

    @State private var result:
        SmithPredictorResult?

    @State private var errorMessage = ""

    private let engine =
        SmithPredictorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "forward.end.alt.fill",
                    title: "Smith Predictor",
                    subtitle: "Reconstruct a dead-time-free process estimate from an FOPDT model",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The Smith predictor uses an internal process model so the feedback controller can react to predicted delay-free behavior.")
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
                            title: "Manipulated-Variable Step",
                            symbol: "Δu",
                            unit: "input units",
                            placeholder: "5",
                            text: $stepInput
                        )

                        EngineeringInputField(
                            title: "Actual Process Gain",
                            symbol: "K",
                            unit: "output/input",
                            placeholder: "2",
                            text: $actualGainInput
                        )

                        EngineeringInputField(
                            title: "Actual Time Constant",
                            symbol: "τ",
                            unit: "time",
                            placeholder: "4",
                            text: $actualTimeInput
                        )

                        EngineeringInputField(
                            title: "Actual Dead Time",
                            symbol: "θ",
                            unit: "time",
                            placeholder: "3",
                            text: $actualDeadInput
                        )

                        EngineeringInputField(
                            title: "Model Process Gain",
                            symbol: "K̂",
                            unit: "output/input",
                            placeholder: "1.9",
                            text: $modelGainInput
                        )

                        EngineeringInputField(
                            title: "Model Time Constant",
                            symbol: "τ̂",
                            unit: "time",
                            placeholder: "4.2",
                            text: $modelTimeInput
                        )

                        EngineeringInputField(
                            title: "Model Dead Time",
                            symbol: "θ̂",
                            unit: "time",
                            placeholder: "2.8",
                            text: $modelDeadInput
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
                            systemImage: "forward.end.alt.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Actual Delayed Output",
                                        value: numberFormatter.format(result.actualDelayedOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Model Delayed Output",
                                        value: numberFormatter.format(result.modelDelayedOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Dead-Time-Free Model",
                                        value: numberFormatter.format(result.modelDeadTimeFreeOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Mismatch Correction",
                                        value: numberFormatter.format(result.modelMismatchCorrection),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Smith Predicted Output",
                                        value: numberFormatter.format(result.smithPredictedOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Prediction Error",
                                        value: numberFormatter.format(result.predictionError),
                                        unit: "output units"
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
        .navigationTitle("Smith Predictor")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialOutput:
                        try InputValidator.parseNumber(
                            initialOutputInput,
                            fieldName:
                                "initial output"
                        ),
                    manipulatedVariableStep:
                        try InputValidator.parseNumber(
                            stepInput,
                            fieldName:
                                "manipulated-variable step"
                        ),
                    actualProcessGain:
                        try InputValidator.parseNumber(
                            actualGainInput,
                            fieldName:
                                "actual process gain"
                        ),
                    actualTimeConstant:
                        try InputValidator.parseNumber(
                            actualTimeInput,
                            fieldName:
                                "actual time constant"
                        ),
                    actualDeadTime:
                        try InputValidator.parseNumber(
                            actualDeadInput,
                            fieldName:
                                "actual dead time"
                        ),
                    modelProcessGain:
                        try InputValidator.parseNumber(
                            modelGainInput,
                            fieldName:
                                "model process gain"
                        ),
                    modelTimeConstant:
                        try InputValidator.parseNumber(
                            modelTimeInput,
                            fieldName:
                                "model time constant"
                        ),
                    modelDeadTime:
                        try InputValidator.parseNumber(
                            modelDeadInput,
                            fieldName:
                                "model dead time"
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
        initialOutputInput = "20"
        stepInput = "5"
        actualGainInput = "2"
        actualTimeInput = "4"
        actualDeadInput = "3"
        modelGainInput = "1.9"
        modelTimeInput = "4.2"
        modelDeadInput = "2.8"
        timeInput = "6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialOutputInput = ""
        stepInput = ""
        actualGainInput = ""
        actualTimeInput = ""
        actualDeadInput = ""
        modelGainInput = ""
        modelTimeInput = ""
        modelDeadInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SmithPredictorView()
    }
}
