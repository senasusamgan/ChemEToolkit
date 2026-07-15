import SwiftUI

struct ReactionRateCalculatorView: View {
    @State private var rateConstantInput = "0.5"
    @State private var concentrationAInput = "2"
    @State private var concentrationBInput = "3"
    @State private var reactionOrderAInput = "1"
    @State private var reactionOrderBInput = "2"
    @State private var stoichiometricCoefficientAInput = "1"
    @State private var stoichiometricCoefficientBInput = "2"

    @State private var result: ReactionRateCalculatorResult?
    @State private var errorMessage = ""

    private let engine = ReactionRateCalculatorEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "speedometer",
                    title: "Reaction Rate Calculator",
                    subtitle: "Calculate power-law reaction and species disappearance rates",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Power-Law Kinetics")
                            .font(.headline)

                        Text("r = k C_A^α C_B^β")
                            .font(.system(size: 19, weight: .semibold))
                            .minimumScaleFactor(0.45)
                            .multilineTextAlignment(.center)

                        Text("For aA + bB → products, −r_A = a·r and −r_B = b·r.")
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
                        Text("Kinetic and Stoichiometric Inputs")
                            .font(.headline)
                        EngineeringInputField(
                            title: "Rate Constant",
                            symbol: "k",
                            unit: "order-dependent",
                            placeholder: "Example: 0.5",
                            text: $rateConstantInput
                        )
                        EngineeringInputField(
                            title: "Concentration A",
                            symbol: "C_A",
                            unit: "mol/m³",
                            placeholder: "Example: 2",
                            text: $concentrationAInput
                        )
                        EngineeringInputField(
                            title: "Concentration B",
                            symbol: "C_B",
                            unit: "mol/m³",
                            placeholder: "Example: 3",
                            text: $concentrationBInput
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
                            systemImage: "speedometer",
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
                        label: "Rate of Reaction",
                        value: numberFormatter.format(
                            result.rateOfReaction
                        ),
                        unit: "mol/(m³·time)"
                    ),
                    .init(
                        label: "Disappearance Rate A",
                        value: numberFormatter.format(
                            result.disappearanceRateA
                        ),
                        unit: "mol/(m³·time)"
                    ),
                    .init(
                        label: "Disappearance Rate B",
                        value: numberFormatter.format(
                            result.disappearanceRateB
                        ),
                        unit: "mol/(m³·time)"
                    ),
                    .init(
                        label: "Characteristic Time for A",
                        value: numberFormatter.format(
                            result.characteristicTimeForA
                        ),
                        unit: "time"
                    )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                    Text(result.rateLawExpression)
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
        .navigationTitle("Reaction Rate")
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

    private func makeInput() throws -> ReactionRateCalculatorInput {
        .init(
            rateConstant:
                try InputValidator.parseNumber(
                    rateConstantInput,
                    fieldName: "rate constant"
                ),
            concentrationA:
                try InputValidator.parseNumber(
                    concentrationAInput,
                    fieldName: "concentration a"
                ),
            concentrationB:
                try InputValidator.parseNumber(
                    concentrationBInput,
                    fieldName: "concentration b"
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
                ),
            stoichiometricCoefficientA:
                try InputValidator.parseNumber(
                    stoichiometricCoefficientAInput,
                    fieldName: "stoichiometric coefficient a"
                ),
            stoichiometricCoefficientB:
                try InputValidator.parseNumber(
                    stoichiometricCoefficientBInput,
                    fieldName: "stoichiometric coefficient b"
                )
        )
    }

    private func loadExample() {
        rateConstantInput = "0.5"
        concentrationAInput = "2"
        concentrationBInput = "3"
        reactionOrderAInput = "1"
        reactionOrderBInput = "2"
        stoichiometricCoefficientAInput = "1"
        stoichiometricCoefficientBInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        rateConstantInput = ""
        concentrationAInput = ""
        concentrationBInput = ""
        reactionOrderAInput = ""
        reactionOrderBInput = ""
        stoichiometricCoefficientAInput = ""
        stoichiometricCoefficientBInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReactionRateCalculatorView()
    }
}
