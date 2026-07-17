import SwiftUI

struct FaultTreeProbabilityView:
    View {

    @State private var event1Input = "0.01"
    @State private var event2Input = "0.02"
    @State private var event3Input = "0.03"
    @State private var gateInput = "1"

    @State private var result:
        FaultTreeProbabilityResult?

    @State private var errorMessage = ""

    private let engine =
        FaultTreeProbabilityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "point.3.connected.trianglepath.dotted",
                    title: "Fault Tree Probability",
                    subtitle: "Calculate independent three-event OR or AND gate probability",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Select an OR or AND gate to combine three independent basic-event probabilities.")
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
                            title: "Basic Event 1 Probability",
                            symbol: "P₁",
                            unit: "—",
                            placeholder: "0.01",
                            text: $event1Input
                        )

                        EngineeringInputField(
                            title: "Basic Event 2 Probability",
                            symbol: "P₂",
                            unit: "—",
                            placeholder: "0.02",
                            text: $event2Input
                        )

                        EngineeringInputField(
                            title: "Basic Event 3 Probability",
                            symbol: "P₃",
                            unit: "—",
                            placeholder: "0.03",
                            text: $event3Input
                        )

                        EngineeringInputField(
                            title: "Gate Code",
                            symbol: "Gate",
                            unit: "1 OR, 2 AND",
                            placeholder: "1",
                            text: $gateInput
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
                            systemImage: "point.3.connected.trianglepath.dotted",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Selected Gate",
                                        value: result.gateName,
                                        unit: "—"
                                    ),
.init(
                                        label: "Top Event Probability",
                                        value: numberFormatter.format(result.topEventProbability),
                                        unit: "—"
                                    ),
.init(
                                        label: "Top Event Complement",
                                        value: numberFormatter.format(result.topEventComplement),
                                        unit: "—"
                                    ),
.init(
                                        label: "Rare-Event Approximation",
                                        value: numberFormatter.format(result.rareEventApproximation),
                                        unit: "—"
                                    ),
.init(
                                        label: "Approximation Error",
                                        value: numberFormatter.format(result.approximationError),
                                        unit: "—"
                                    ),
.init(
                                        label: "Dominant Basic Event",
                                        value: result.dominantBasicEvent,
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
        .navigationTitle("Fault Tree Probability")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    basicEvent1Probability:
                        try InputValidator.parseNumber(
                            event1Input,
                            fieldName:
                                "basic event 1 probability"
                        ),
                    basicEvent2Probability:
                        try InputValidator.parseNumber(
                            event2Input,
                            fieldName:
                                "basic event 2 probability"
                        ),
                    basicEvent3Probability:
                        try InputValidator.parseNumber(
                            event3Input,
                            fieldName:
                                "basic event 3 probability"
                        ),
                    gateCode:
                        try InputValidator.parseNumber(
                            gateInput,
                            fieldName:
                                "gate code"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        event1Input = "0.01"
        event2Input = "0.02"
        event3Input = "0.03"
        gateInput = "1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        event1Input = ""
        event2Input = ""
        event3Input = ""
        gateInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FaultTreeProbabilityView()
    }
}
