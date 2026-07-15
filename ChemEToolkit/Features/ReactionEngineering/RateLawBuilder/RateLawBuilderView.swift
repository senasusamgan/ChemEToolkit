import SwiftUI

struct RateLawBuilderView: View {
    @State private var stoichiometricCoefficientAInput = "1"
    @State private var stoichiometricCoefficientBInput = "2"
    @State private var reactionOrderAInput = "1"
    @State private var reactionOrderBInput = "2"

    @State private var result: RateLawBuilderResult?
    @State private var errorMessage = ""

    private let engine = RateLawBuilderEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "function",
                    title: "Rate-Law Builder",
                    subtitle: "Build kinetic, stoichiometric and rate-constant expressions",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Reaction and Kinetic Orders")
                            .font(.headline)

                        Text("aA + bB → products")
                            .font(.system(size: 19, weight: .semibold))
                            .minimumScaleFactor(0.45)
                            .multilineTextAlignment(.center)

                        Text("Reaction orders are experimental unless the reaction is known to be elementary.")
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
                        Text("Stoichiometry and Orders")
                            .font(.headline)
                        EngineeringInputField(
                            title: "Stoichiometric Coefficient A",
                            symbol: "a",
                            unit: "—",
                            placeholder: "Example: 1",
                            text: $stoichiometricCoefficientAInput
                        )
                        EngineeringInputField(
                            title: "Stoichiometric Coefficient B",
                            symbol: "b",
                            unit: "—",
                            placeholder: "Example: 2",
                            text: $stoichiometricCoefficientBInput
                        )
                        EngineeringInputField(
                            title: "Reaction Order in A",
                            symbol: "α",
                            unit: "—",
                            placeholder: "Example: 1",
                            text: $reactionOrderAInput
                        )
                        EngineeringInputField(
                            title: "Reaction Order in B",
                            symbol: "β",
                            unit: "—",
                            placeholder: "Example: 2",
                            text: $reactionOrderBInput
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
                            systemImage: "function",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                    .init(
                        label: "Overall Reaction Order",
                        value: numberFormatter.format(
                            result.overallReactionOrder
                        ),
                        unit: "—"
                    ),
                    .init(
                        label: "k Concentration Exponent",
                        value: numberFormatter.format(
                            result.rateConstantConcentrationExponent
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
                    Text(result.powerLawExpression)
                    Text(result.stoichiometricRateRelationship)
                    Text("k units: \(result.rateConstantUnitsDescription)")
                    Text(result.consistencyDescription)

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
        .navigationTitle("Rate-Law Builder")
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

    private func makeInput() throws -> RateLawBuilderInput {
        .init(
            stoichiometricCoefficientA:
                try InputValidator.parseNumber(
                    stoichiometricCoefficientAInput,
                    fieldName: "stoichiometric coefficient a"
                ),
            stoichiometricCoefficientB:
                try InputValidator.parseNumber(
                    stoichiometricCoefficientBInput,
                    fieldName: "stoichiometric coefficient b"
                ),
            reactionOrderA:
                try InputValidator.parseNumber(
                    reactionOrderAInput,
                    fieldName: "reaction order in a"
                ),
            reactionOrderB:
                try InputValidator.parseNumber(
                    reactionOrderBInput,
                    fieldName: "reaction order in b"
                )
        )
    }

    private func loadExample() {
        stoichiometricCoefficientAInput = "1"
        stoichiometricCoefficientBInput = "2"
        reactionOrderAInput = "1"
        reactionOrderBInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        stoichiometricCoefficientAInput = ""
        stoichiometricCoefficientBInput = ""
        reactionOrderAInput = ""
        reactionOrderBInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RateLawBuilderView()
    }
}
