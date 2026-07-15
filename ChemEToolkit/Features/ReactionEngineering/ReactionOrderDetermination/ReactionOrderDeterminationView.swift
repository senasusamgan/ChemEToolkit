import SwiftUI

struct ReactionOrderDeterminationView: View {
    @State private var concentrationExperimentOneInput = "1"
    @State private var rateExperimentOneInput = "0.5"
    @State private var concentrationExperimentTwoInput = "2"
    @State private var rateExperimentTwoInput = "2"

    @State private var result: ReactionOrderDeterminationResult?
    @State private var errorMessage = ""

    private let engine = ReactionOrderDeterminationEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.xyaxis.line",
                    title: "Reaction Order Determination",
                    subtitle: "Determine a single-reactant order from two initial-rate experiments",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Initial-Rates Ratio Method")
                            .font(.headline)

                        Text("n = ln(r₂/r₁) / ln(C₂/C₁)")
                            .font(.system(size: 19, weight: .semibold))
                            .minimumScaleFactor(0.45)
                            .multilineTextAlignment(.center)

                        Text("Temperature and all other reactant concentrations must remain constant.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        Text("Two Initial-Rate Experiments")
                            .font(.headline)
                        EngineeringInputField(
                            title: "Experiment 1 Concentration",
                            symbol: "C₁",
                            unit: "mol/m³",
                            placeholder: "Example: 1",
                            text: $concentrationExperimentOneInput
                        )
                        EngineeringInputField(
                            title: "Experiment 1 Initial Rate",
                            symbol: "r₁",
                            unit: "mol/(m³·time)",
                            placeholder: "Example: 0.5",
                            text: $rateExperimentOneInput
                        )
                        EngineeringInputField(
                            title: "Experiment 2 Concentration",
                            symbol: "C₂",
                            unit: "mol/m³",
                            placeholder: "Example: 2",
                            text: $concentrationExperimentTwoInput
                        )
                        EngineeringInputField(
                            title: "Experiment 2 Initial Rate",
                            symbol: "r₂",
                            unit: "mol/(m³·time)",
                            placeholder: "Example: 2",
                            text: $rateExperimentTwoInput
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
                            title: "Calculate",
                            systemImage: "chart.xyaxis.line",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                    .init(
                        label: "Reaction Order",
                        value: numberFormatter.format(
                            result.reactionOrder
                        ),
                        unit: "—"
                    ),
                    .init(
                        label: "k from Experiment 1",
                        value: numberFormatter.format(
                            result.rateConstantFromExperimentOne
                        ),
                        unit: "order-dependent"
                    ),
                    .init(
                        label: "k from Experiment 2",
                        value: numberFormatter.format(
                            result.rateConstantFromExperimentTwo
                        ),
                        unit: "order-dependent"
                    ),
                    .init(
                        label: "Average Rate Constant",
                        value: numberFormatter.format(
                            result.averageRateConstant
                        ),
                        unit: "order-dependent"
                    ),
                    .init(
                        label: "Relative k Mismatch",
                        value: numberFormatter.format(
                            100 * result.relativeRateConstantMismatch
                        ),
                        unit: "%"
                    )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                    Text(result.classification.title)
                    Text("k units: \(result.rateConstantUnitsDescription)")

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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Reaction Order")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func makeInput() throws -> ReactionOrderDeterminationInput {
        .init(
            concentrationExperimentOne:
                try InputValidator.parseNumber(
                    concentrationExperimentOneInput,
                    fieldName: "experiment 1 concentration"
                ),
            rateExperimentOne:
                try InputValidator.parseNumber(
                    rateExperimentOneInput,
                    fieldName: "experiment 1 initial rate"
                ),
            concentrationExperimentTwo:
                try InputValidator.parseNumber(
                    concentrationExperimentTwoInput,
                    fieldName: "experiment 2 concentration"
                ),
            rateExperimentTwo:
                try InputValidator.parseNumber(
                    rateExperimentTwoInput,
                    fieldName: "experiment 2 initial rate"
                )
        )
    }

    private func loadExample() {
        concentrationExperimentOneInput = "1"
        rateExperimentOneInput = "0.5"
        concentrationExperimentTwoInput = "2"
        rateExperimentTwoInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationExperimentOneInput = ""
        rateExperimentOneInput = ""
        concentrationExperimentTwoInput = ""
        rateExperimentTwoInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReactionOrderDeterminationView()
    }
}
