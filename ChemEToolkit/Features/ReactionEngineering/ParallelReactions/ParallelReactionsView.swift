import SwiftUI

struct ParallelReactionsView:
    View {

    @State private var initialConcentrationInput = "2"
    @State private var desiredRateInput = "0.2"
    @State private var undesiredRateInput = "0.1"
    @State private var reactionTimeInput = "5"

    @State private var result:
        ParallelReactionsResult?

    @State private var errorMessage = ""

    private let engine =
        ParallelReactionsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.triangle.branch",
                    title: "Parallel Reactions",
                    subtitle:
                        "Calculate conversion, yield and selectivity for competing first-order paths",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Competing Paths")
                            .font(.headline)

                        Text(
                            "A → D,  A → U"
                        )
                        .font(
                            .system(
                                size: 21,
                                weight: .semibold
                            )
                        )

                        Text(
                            "For two first-order paths, the product split is fixed by k_D/(k_D+k_U)."
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
                            placeholder: "Example: 2",
                            text:
                                $initialConcentrationInput
                        )

                        EngineeringInputField(
                            title:
                                "Desired-Path Rate Constant",
                            symbol: "k_D",
                            unit: "1/time",
                            placeholder: "Example: 0.2",
                            text: $desiredRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Undesired-Path Rate Constant",
                            symbol: "k_U",
                            unit: "1/time",
                            placeholder: "Example: 0.1",
                            text: $undesiredRateInput
                        )

                        EngineeringInputField(
                            title: "Reaction Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "Example: 5",
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
                                "Calculate Product Split",
                            systemImage:
                                "arrow.triangle.branch",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Final Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalConcentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Desired Product",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .desiredProductConcentration
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Undesired Product",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .undesiredProductConcentration
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Reactant Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .reactantConversionFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Desired Yield on Feed",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .desiredYieldOnFeedFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Desired Selectivity",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .desiredSelectivityFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Desired / Undesired Ratio",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .desiredToUndesiredSelectivityRatio
                                                ),
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
        .navigationTitle("Parallel Reactions")
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
                    desiredFirstOrderRateConstant:
                        try InputValidator.parseNumber(
                            desiredRateInput,
                            fieldName:
                                "desired-path rate constant"
                        ),
                    undesiredFirstOrderRateConstant:
                        try InputValidator.parseNumber(
                            undesiredRateInput,
                            fieldName:
                                "undesired-path rate constant"
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
        initialConcentrationInput = "2"
        desiredRateInput = "0.2"
        undesiredRateInput = "0.1"
        reactionTimeInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialConcentrationInput = ""
        desiredRateInput = ""
        undesiredRateInput = ""
        reactionTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ParallelReactionsView()
    }
}
