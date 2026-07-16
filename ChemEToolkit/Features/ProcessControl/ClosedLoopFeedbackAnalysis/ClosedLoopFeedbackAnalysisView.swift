import SwiftUI

struct ClosedLoopFeedbackAnalysisView: View {
    @State private var forwardInput = "4"
    @State private var feedbackInput = "1"
    @State private var referenceInput = "10"
    @State private var disturbanceInput = "2"
    @State private var result: ClosedLoopFeedbackAnalysisResult?
    @State private var errorMessage = ""

    private let engine = ClosedLoopFeedbackAnalysisEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.2.circlepath",
                    title: "Closed-Loop Feedback",
                    subtitle: "Analyze tracking, sensitivity and disturbance transmission",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("For standard negative feedback, the closed-loop denominator is 1 + GH.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Forward-Path Gain",
                            symbol: "G",
                            unit: "output/input",
                            placeholder: "4",
                            text: $forwardInput
                        )

                        EngineeringInputField(
                            title: "Feedback-Path Gain",
                            symbol: "H",
                            unit: "feedback/output",
                            placeholder: "1",
                            text: $feedbackInput
                        )

                        EngineeringInputField(
                            title: "Reference Input",
                            symbol: "r",
                            unit: "input units",
                            placeholder: "10",
                            text: $referenceInput
                        )

                        EngineeringInputField(
                            title: "Output Disturbance",
                            symbol: "d",
                            unit: "output units",
                            placeholder: "2",
                            text: $disturbanceInput
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
                            systemImage: "arrow.triangle.2.circlepath",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Loop Gain",
                                        value: numberFormatter.format(result.loopGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Closed-Loop Reference Gain",
                                        value: numberFormatter.format(result.closedLoopReferenceGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Sensitivity",
                                        value: numberFormatter.format(result.sensitivityFunction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Complementary Sensitivity",
                                        value: numberFormatter.format(result.complementarySensitivity),
                                        unit: "—"
                                    ),
.init(
                                        label: "Total Output",
                                        value: numberFormatter.format(result.totalOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Tracking Error",
                                        value: numberFormatter.format(result.referenceTrackingError),
                                        unit: "input units"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Closed-Loop Feedback")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    forwardPathGain: try InputValidator.parseNumber(forwardInput, fieldName: "forward-path gain"),
                    feedbackPathGain: try InputValidator.parseNumber(feedbackInput, fieldName: "feedback-path gain"),
                    referenceInput: try InputValidator.parseNumber(referenceInput, fieldName: "reference input"),
                    outputDisturbance: try InputValidator.parseNumber(disturbanceInput, fieldName: "output disturbance")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        forwardInput = "4"
        feedbackInput = "1"
        referenceInput = "10"
        disturbanceInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        forwardInput = ""
        feedbackInput = ""
        referenceInput = ""
        disturbanceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { ClosedLoopFeedbackAnalysisView() } }
