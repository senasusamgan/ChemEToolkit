import SwiftUI

struct HAZOPGuideWordAssistantView:
    View {

    @State private var parameterInput = "Flow"
    @State private var designIntentInput = "Transfer feed at 20 m³/h"
    @State private var guideWordInput = "2"
    @State private var contextInput = "Feed line to reactor"

    @State private var result:
        HAZOPGuideWordAssistantResult?

    @State private var errorMessage = ""

    private let engine =
        HAZOPGuideWordAssistantEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "list.bullet.clipboard.fill",
                    title: "HAZOP Guide Word Assistant",
                    subtitle: "Generate structured deviation, cause and consequence prompts",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Enter a parameter, design intent and guide-word code to create a worksheet-ready HAZOP prompt.")
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
                            title: "Process Parameter",
                            symbol: "Parameter",
                            unit: "text",
                            placeholder: "Flow",
                            text: $parameterInput
                        )

                        EngineeringInputField(
                            title: "Design Intent",
                            symbol: "Intent",
                            unit: "text",
                            placeholder: "Transfer feed at 20 m³/h",
                            text: $designIntentInput
                        )

                        EngineeringInputField(
                            title: "Guide-Word Code",
                            symbol: "Code",
                            unit: "1 No, 2 More, 3 Less, 4 As Well As, 5 Part Of, 6 Reverse, 7 Other Than",
                            placeholder: "2",
                            text: $guideWordInput
                        )

                        EngineeringInputField(
                            title: "Node Context",
                            symbol: "Node",
                            unit: "optional text",
                            placeholder: "Feed line to reactor",
                            text: $contextInput
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
                            systemImage: "list.bullet.clipboard.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Guide Word",
                                        value: result.guideWord,
                                        unit: "—"
                                    ),
.init(
                                        label: "Deviation",
                                        value: result.deviationPhrase,
                                        unit: "—"
                                    ),
.init(
                                        label: "Cause Prompt",
                                        value: result.causePrompt,
                                        unit: "—"
                                    ),
.init(
                                        label: "Consequence Prompt",
                                        value: result.consequencePrompt,
                                        unit: "—"
                                    ),
.init(
                                        label: "Safeguard Prompt",
                                        value: result.safeguardPrompt,
                                        unit: "—"
                                    ),
.init(
                                        label: "Worksheet Summary",
                                        value: result.worksheetSummary,
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
        .navigationTitle("HAZOP Guide Word Assistant")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    processParameter:
                        parameterInput,
                    designIntent:
                        designIntentInput,
                    guideWordCode:
                        try InputValidator.parseNumber(
                            guideWordInput,
                            fieldName:
                                "guide-word code"
                        ),
                    nodeContext:
                        contextInput
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        parameterInput = "Flow"
        designIntentInput = "Transfer feed at 20 m³/h"
        guideWordInput = "2"
        contextInput = "Feed line to reactor"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        parameterInput = ""
        designIntentInput = ""
        guideWordInput = ""
        contextInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        HAZOPGuideWordAssistantView()
    }
}
