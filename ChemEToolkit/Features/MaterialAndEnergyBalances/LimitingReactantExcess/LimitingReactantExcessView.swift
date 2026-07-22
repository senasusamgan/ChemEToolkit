import SwiftUI

struct LimitingReactantExcessView:
    View {

    @State private var amountAInput = "10"
    @State private var coefficientAInput = "2"
    @State private var amountBInput = "8"
    @State private var coefficientBInput = "1"

    @State private var result:
        LimitingReactantExcessResult?

    @State private var errorMessage = ""

    private let engine =
        LimitingReactantExcessEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scalemass.fill",
                    title: "Limiting & Excess Reactant",
                    subtitle: "Determine limiting reactant and percent excess",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Amounts must use the same molar basis and coefficients must match the balanced reaction.")
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
                            title: "Reactant A Amount",
                            symbol: "n_A",
                            unit: "mol or kmol",
                            placeholder: "10",
                            text: $amountAInput
                        )

                        EngineeringInputField(
                            title: "Coefficient A",
                            symbol: "ν_A",
                            unit: "—",
                            placeholder: "2",
                            text: $coefficientAInput
                        )

                        EngineeringInputField(
                            title: "Reactant B Amount",
                            symbol: "n_B",
                            unit: "same unit",
                            placeholder: "8",
                            text: $amountBInput
                        )

                        EngineeringInputField(
                            title: "Coefficient B",
                            symbol: "ν_B",
                            unit: "—",
                            placeholder: "1",
                            text: $coefficientBInput
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
                            systemImage: "scalemass.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Limiting Reactant",
                                        value: result.limitingReactant,
                                        unit: "—"
                                    ),
.init(
                                        label: "Maximum Reaction Extent",
                                        value: numberFormatter.format(result.maximumReactionExtent),
                                        unit: "reaction amount"
                                    ),
.init(
                                        label: "Reactant A Remaining",
                                        value: numberFormatter.format(result.amountARemaining),
                                        unit: "input amount unit"
                                    ),
.init(
                                        label: "Reactant B Remaining",
                                        value: numberFormatter.format(result.amountBRemaining),
                                        unit: "input amount unit"
                                    ),
.init(
                                        label: "Excess Reactant",
                                        value: result.excessReactant,
                                        unit: "—"
                                    ),
.init(
                                        label: "Percent Excess",
                                        value: numberFormatter.format(result.percentExcess),
                                        unit: "%"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
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
        .navigationTitle("Limiting & Excess Reactant")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    amountA:
                        try InputValidator.parseNumber(
                            amountAInput,
                            fieldName:
                                "reactant A amount"
                        ),
                    stoichiometricCoefficientA:
                        try InputValidator.parseNumber(
                            coefficientAInput,
                            fieldName:
                                "coefficient A"
                        ),
                    amountB:
                        try InputValidator.parseNumber(
                            amountBInput,
                            fieldName:
                                "reactant B amount"
                        ),
                    stoichiometricCoefficientB:
                        try InputValidator.parseNumber(
                            coefficientBInput,
                            fieldName:
                                "coefficient B"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        amountAInput = "10"
        coefficientAInput = "2"
        amountBInput = "8"
        coefficientBInput = "1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        amountAInput = ""
        coefficientAInput = ""
        amountBInput = ""
        coefficientBInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LimitingReactantExcessView()
    }
}
