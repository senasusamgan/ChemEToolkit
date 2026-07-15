import SwiftUI

struct SeriesParallelReactionsView:
    View {

    @State private var initialConcentrationInput = "1"
    @State private var rateABInput = "0.4"
    @State private var rateBCInput = "0.15"
    @State private var rateADInput = "0.1"
    @State private var reactionTimeInput = "3"

    @State private var result:
        SeriesParallelReactionsResult?

    @State private var errorMessage = ""

    private let engine =
        SeriesParallelReactionsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "point.3.connected.trianglepath.dotted",
                    title:
                        "Series–Parallel Reactions",
                    subtitle:
                        "Track desired intermediate B with series loss and parallel byproduct formation",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Combined Reaction Network")
                            .font(.headline)

                        Text(
                            "A → B → C,  A → D"
                        )
                        .font(
                            .system(
                                size: 21,
                                weight: .semibold
                            )
                        )

                        Text(
                            "B is produced from A but lost to C while A also forms the parallel byproduct D."
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
                            symbol: "k_AB",
                            unit: "1/time",
                            placeholder: "Example: 0.4",
                            text: $rateABInput
                        )

                        EngineeringInputField(
                            title:
                                "B → C Rate Constant",
                            symbol: "k_BC",
                            unit: "1/time",
                            placeholder: "Example: 0.15",
                            text: $rateBCInput
                        )

                        EngineeringInputField(
                            title:
                                "A → D Rate Constant",
                            symbol: "k_AD",
                            unit: "1/time",
                            placeholder: "Example: 0.1",
                            text: $rateADInput
                        )

                        EngineeringInputField(
                            title: "Reaction Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "Example: 3",
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
                                "Calculate Reaction Network",
                            systemImage:
                                "point.3.connected.trianglepath.dotted",
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
                                                "Desired Intermediate B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .desiredIntermediateB
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Series Product C",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .seriesProductC
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Parallel Byproduct D",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .parallelByproductD
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
                                                "Desired Yield on Feed",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .desiredYieldOnFeed
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Time of Maximum B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .timeOfMaximumB
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Maximum B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .maximumConcentrationB
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
        .navigationTitle("Series–Parallel")
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
                    rateConstantAToB:
                        try InputValidator.parseNumber(
                            rateABInput,
                            fieldName:
                                "A to B rate constant"
                        ),
                    rateConstantBToC:
                        try InputValidator.parseNumber(
                            rateBCInput,
                            fieldName:
                                "B to C rate constant"
                        ),
                    rateConstantAToD:
                        try InputValidator.parseNumber(
                            rateADInput,
                            fieldName:
                                "A to D rate constant"
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
        rateABInput = "0.4"
        rateBCInput = "0.15"
        rateADInput = "0.1"
        reactionTimeInput = "3"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialConcentrationInput = ""
        rateABInput = ""
        rateBCInput = ""
        rateADInput = ""
        reactionTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SeriesParallelReactionsView()
    }
}
