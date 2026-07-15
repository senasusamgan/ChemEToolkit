import SwiftUI

struct RateConstantCalculationView: View {
    @State private var measuredReactionRateInput = "9"
    @State private var concentrationAInput = "2"
    @State private var concentrationBInput = "3"
    @State private var reactionOrderAInput = "1"
    @State private var reactionOrderBInput = "2"

    @State private var result: RateConstantCalculationResult?
    @State private var errorMessage = ""

    private let engine = RateConstantCalculationEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "k.square.fill",
                    title: "Rate Constant Calculation",
                    subtitle: "Calculate k from a measured rate, concentrations and reaction orders",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Power-Law Rearrangement")
                            .font(.headline)

                        Text("k = r / (C_A^α C_B^β)")
                            .font(.system(size: 19, weight: .semibold))
                            .minimumScaleFactor(0.45)
                            .multilineTextAlignment(.center)

                        Text("The dimensions of k depend on the overall reaction order.")
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
                        Text("Measured Rate and Kinetic Inputs")
                            .font(.headline)
                        EngineeringInputField(
                            title: "Measured Reaction Rate",
                            symbol: "r",
                            unit: "mol/(m³·time)",
                            placeholder: "Example: 9",
                            text: $measuredReactionRateInput
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
                            systemImage: "k.square.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                    .init(
                        label: "Rate Constant",
                        value: numberFormatter.format(
                            result.rateConstant
                        ),
                        unit: "order-dependent"
                    ),
                    .init(
                        label: "Overall Reaction Order",
                        value: numberFormatter.format(
                            result.overallReactionOrder
                        ),
                        unit: "—"
                    ),
                    .init(
                        label: "Concentration Product",
                        value: numberFormatter.format(
                            result.concentrationProduct
                        ),
                        unit: "order-dependent"
                    ),
                    .init(
                        label: "Observed Constant with B Fixed",
                        value: numberFormatter.format(
                            result.observedConstantWithBFixed
                        ),
                        unit: "order-dependent"
                    ),
                    .init(
                        label: "Observed Constant with A Fixed",
                        value: numberFormatter.format(
                            result.observedConstantWithAFixed
                        ),
                        unit: "order-dependent"
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
        .navigationTitle("Rate Constant")
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

    private func makeInput() throws -> RateConstantCalculationInput {
        .init(
            measuredReactionRate:
                try InputValidator.parseNumber(
                    measuredReactionRateInput,
                    fieldName: "measured reaction rate"
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
                )
        )
    }

    private func loadExample() {
        measuredReactionRateInput = "9"
        concentrationAInput = "2"
        concentrationBInput = "3"
        reactionOrderAInput = "1"
        reactionOrderBInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        measuredReactionRateInput = ""
        concentrationAInput = ""
        concentrationBInput = ""
        reactionOrderAInput = ""
        reactionOrderBInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RateConstantCalculationView()
    }
}
