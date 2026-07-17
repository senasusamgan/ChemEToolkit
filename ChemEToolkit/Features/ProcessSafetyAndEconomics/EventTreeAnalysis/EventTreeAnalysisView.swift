import SwiftUI

struct EventTreeAnalysisView:
    View {

    @State private var frequencyInput = "0.1"
    @State private var barrier1Input = "0.9"
    @State private var barrier2Input = "0.8"
    @State private var barrier3Input = "0.95"

    @State private var result:
        EventTreeAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        EventTreeAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.branch",
                    title: "Event Tree Analysis",
                    subtitle: "Calculate sequential barrier-outcome frequencies",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The event tree partitions one initiating-event frequency into mutually exclusive sequential outcomes.")
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
                            title: "Initiating Event Frequency",
                            symbol: "f_IE",
                            unit: "1/year",
                            placeholder: "0.1",
                            text: $frequencyInput
                        )

                        EngineeringInputField(
                            title: "Barrier 1 Success Probability",
                            symbol: "P₁",
                            unit: "—",
                            placeholder: "0.9",
                            text: $barrier1Input
                        )

                        EngineeringInputField(
                            title: "Barrier 2 Success Probability",
                            symbol: "P₂",
                            unit: "—",
                            placeholder: "0.8",
                            text: $barrier2Input
                        )

                        EngineeringInputField(
                            title: "Barrier 3 Success Probability",
                            symbol: "P₃",
                            unit: "—",
                            placeholder: "0.95",
                            text: $barrier3Input
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
                            systemImage: "arrow.triangle.branch",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Barrier 1 Failure Outcome",
                                        value: numberFormatter.format(result.barrier1FailureOutcomeFrequency),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Barrier 2 Failure Outcome",
                                        value: numberFormatter.format(result.barrier2FailureOutcomeFrequency),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Barrier 3 Failure Outcome",
                                        value: numberFormatter.format(result.barrier3FailureOutcomeFrequency),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "All Barriers Successful",
                                        value: numberFormatter.format(result.allBarriersSuccessfulFrequency),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Full Success Probability",
                                        value: numberFormatter.format(100 * result.fullSuccessProbability),
                                        unit: "%"
                                    ),
.init(
                                        label: "Dominant Outcome",
                                        value: result.dominantOutcome,
                                        unit: "—"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Event Tree Analysis")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initiatingEventFrequency:
                        try InputValidator.parseNumber(
                            frequencyInput,
                            fieldName:
                                "initiating event frequency"
                        ),
                    barrier1SuccessProbability:
                        try InputValidator.parseNumber(
                            barrier1Input,
                            fieldName:
                                "barrier 1 success probability"
                        ),
                    barrier2SuccessProbability:
                        try InputValidator.parseNumber(
                            barrier2Input,
                            fieldName:
                                "barrier 2 success probability"
                        ),
                    barrier3SuccessProbability:
                        try InputValidator.parseNumber(
                            barrier3Input,
                            fieldName:
                                "barrier 3 success probability"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        frequencyInput = "0.1"
        barrier1Input = "0.9"
        barrier2Input = "0.8"
        barrier3Input = "0.95"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        frequencyInput = ""
        barrier1Input = ""
        barrier2Input = ""
        barrier3Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EventTreeAnalysisView()
    }
}
