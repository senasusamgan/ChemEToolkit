import SwiftUI

struct ReversibleReactionsView:
    View {

    @State private var initialAInput = "1"
    @State private var initialBInput = "0"
    @State private var forwardRateInput = "0.4"
    @State private var reverseRateInput = "0.1"
    @State private var reactionTimeInput = "5"

    @State private var result:
        ReversibleReactionsResult?

    @State private var errorMessage = ""

    private let engine =
        ReversibleReactionsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right",
                    title: "Reversible Reactions",
                    subtitle:
                        "Calculate equilibrium approach for a first-order A ⇌ B system",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("First-Order Reversible Batch Reaction")
                            .font(.headline)

                        Text("A ⇌ B")
                            .font(
                                .system(
                                    size: 23,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "K = k_f/k_r and deviations from equilibrium decay as exp[−(k_f+k_r)t]."
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
                            text: $initialAInput
                        )

                        EngineeringInputField(
                            title:
                                "Initial Concentration B",
                            symbol: "C_B0",
                            unit: "mol/m³",
                            placeholder: "Example: 0",
                            text: $initialBInput
                        )

                        EngineeringInputField(
                            title:
                                "Forward Rate Constant",
                            symbol: "k_f",
                            unit: "1/time",
                            placeholder: "Example: 0.4",
                            text: $forwardRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Reverse Rate Constant",
                            symbol: "k_r",
                            unit: "1/time",
                            placeholder: "Example: 0.1",
                            text: $reverseRateInput
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
                                "Calculate Equilibrium Approach",
                            systemImage:
                                "arrow.left.arrow.right",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Equilibrium Constant",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .equilibriumConstant
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Equilibrium Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .equilibriumConcentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Equilibrium Concentration B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .equilibriumConcentrationB
                                                ),
                                            unit: "mol/m³"
                                        ),
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
                                                "Final Concentration B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalConcentrationB
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Signed Extent",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .signedExtentConcentration
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Approach to Equilibrium",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .approachToEquilibriumFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Final Net Rate",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalNetRate
                                                ),
                                            unit:
                                                "mol/(m³·time)"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(
                                            result
                                                .directionDescription
                                        )
                                        .font(.headline)

                                        Divider()

                                        Text(result.modelName)

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
        .navigationTitle("Reversible Reaction")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialConcentrationA:
                        try InputValidator.parseNumber(
                            initialAInput,
                            fieldName:
                                "initial concentration A"
                        ),
                    initialConcentrationB:
                        try InputValidator.parseNumber(
                            initialBInput,
                            fieldName:
                                "initial concentration B"
                        ),
                    forwardFirstOrderRateConstant:
                        try InputValidator.parseNumber(
                            forwardRateInput,
                            fieldName:
                                "forward rate constant"
                        ),
                    reverseFirstOrderRateConstant:
                        try InputValidator.parseNumber(
                            reverseRateInput,
                            fieldName:
                                "reverse rate constant"
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
        initialAInput = "1"
        initialBInput = "0"
        forwardRateInput = "0.4"
        reverseRateInput = "0.1"
        reactionTimeInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialAInput = ""
        initialBInput = ""
        forwardRateInput = ""
        reverseRateInput = ""
        reactionTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReversibleReactionsView()
    }
}
