import SwiftUI

struct BlockDiagramAlgebraView: View {
    @State private var firstInput = "2"
    @State private var secondInput = "3"
    @State private var feedbackInput = "0.1"

    @State private var result: BlockDiagramAlgebraResult?
    @State private var errorMessage = ""

    private let engine = BlockDiagramAlgebraEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.grid.2x2",
                    title: "Block-Diagram Algebra",
                    subtitle: "Reduce series, parallel and feedback gain structures",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("For the cascaded forward path G₁G₂, negative feedback gives G/(1+GH).")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "First Forward Block",
                            symbol: "G₁",
                            unit: "—",
                            placeholder: "2",
                            text: $firstInput
                        )

                        EngineeringInputField(
                            title: "Second Forward Block",
                            symbol: "G₂",
                            unit: "—",
                            placeholder: "3",
                            text: $secondInput
                        )

                        EngineeringInputField(
                            title: "Feedback Block",
                            symbol: "H",
                            unit: "—",
                            placeholder: "0.1",
                            text: $feedbackInput
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
                            systemImage: "square.grid.2x2",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Series Gain",
                                        value: numberFormatter.format(result.seriesGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Parallel Gain",
                                        value: numberFormatter.format(result.parallelGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Loop Gain",
                                        value: numberFormatter.format(result.loopGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Negative-Feedback Gain",
                                        value: result.negativeFeedbackGain.map { numberFormatter.format($0) } ?? "Singular",
                                        unit: "—"
                                    ),
.init(
                                        label: "Positive-Feedback Gain",
                                        value: result.positiveFeedbackGain.map { numberFormatter.format($0) } ?? "Singular",
                                        unit: "—"
                                    ),
.init(
                                        label: "Reduction Status",
                                        value: result.singularityDescription,
                                        unit: "—"
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
        .navigationTitle("Block-Diagram Algebra")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    firstForwardBlockGain: try InputValidator.parseNumber(
                        firstInput,
                        fieldName: "first forward-block gain"
                    ),
                    secondForwardBlockGain: try InputValidator.parseNumber(
                        secondInput,
                        fieldName: "second forward-block gain"
                    ),
                    feedbackBlockGain: try InputValidator.parseNumber(
                        feedbackInput,
                        fieldName: "feedback-block gain"
                    )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        firstInput = "2"
        secondInput = "3"
        feedbackInput = "0.1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        firstInput = ""
        secondInput = ""
        feedbackInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { BlockDiagramAlgebraView() }
}
