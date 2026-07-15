import SwiftUI

struct SeriesReactionsView:
    View {

    @State private var initialConcentrationInput = "1"
    @State private var firstRateInput = "0.5"
    @State private var secondRateInput = "0.2"
    @State private var reactionTimeInput = "4"

    @State private var result:
        SeriesReactionsResult?

    @State private var errorMessage = ""

    private let engine =
        SeriesReactionsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.right.arrow.right",
                    title: "Series Reactions",
                    subtitle:
                        "Track reactant, intermediate and final product in A → B → C",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Consecutive First-Order Reactions")
                            .font(.headline)

                        Text("A → B → C")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "The intermediate B rises to a maximum and then falls as it is converted to C."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
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
                            title:
                                "Initial Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 1",
                            text:
                                $initialConcentrationInput
                        )

                        EngineeringInputField(
                            title:
                                "A → B Rate Constant",
                            symbol: "k₁",
                            unit: "1/time",
                            placeholder: "Example: 0.5",
                            text: $firstRateInput
                        )

                        EngineeringInputField(
                            title:
                                "B → C Rate Constant",
                            symbol: "k₂",
                            unit: "1/time",
                            placeholder: "Example: 0.2",
                            text: $secondRateInput
                        )

                        EngineeringInputField(
                            title: "Reaction Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "Example: 4",
                            text: $reactionTimeInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
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
                            title:
                                "Calculate Concentration Profile",
                            systemImage:
                                "arrow.right.arrow.right",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .concentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Intermediate B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .intermediateConcentrationB
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Final Product C",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalProductConcentrationC
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Conversion of A",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionOfA
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Intermediate Yield",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .intermediateYieldOnFeed
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Time of Maximum B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .timeOfMaximumIntermediate
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Maximum B Concentration",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .maximumIntermediateConcentration
                                                ),
                                            unit: "mol/m³"
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
        .navigationTitle("Series Reactions")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialConcentrationA:
                        try InputValidator.parseNumber(
                            initialConcentrationInput,
                            fieldName:
                                "initial concentration A"
                        ),
                    firstStepRateConstant:
                        try InputValidator.parseNumber(
                            firstRateInput,
                            fieldName:
                                "first-step rate constant"
                        ),
                    secondStepRateConstant:
                        try InputValidator.parseNumber(
                            secondRateInput,
                            fieldName:
                                "second-step rate constant"
                        ),
                    reactionTime:
                        try InputValidator.parseNumber(
                            reactionTimeInput,
                            fieldName:
                                "reaction time"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialConcentrationInput = "1"
        firstRateInput = "0.5"
        secondRateInput = "0.2"
        reactionTimeInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialConcentrationInput = ""
        firstRateInput = ""
        secondRateInput = ""
        reactionTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SeriesReactionsView()
    }
}
