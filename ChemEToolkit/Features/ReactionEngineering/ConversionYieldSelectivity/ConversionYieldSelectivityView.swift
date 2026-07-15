import SwiftUI

struct ConversionYieldSelectivityView:
    View {

    @State private var initialReactantInput = "100"
    @State private var finalReactantInput = "20"
    @State private var desiredProductInput = "60"
    @State private var undesiredProductInput = "10"
    @State private var desiredStoichiometricYieldInput = "1"
    @State private var undesiredStoichiometricYieldInput = "0.5"

    @State private var result:
        ConversionYieldSelectivityResult?

    @State private var errorMessage = ""

    private let engine =
        ConversionYieldSelectivityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "target",
                    title: "Conversion, Yield & Selectivity",
                    subtitle:
                        "Account for reactant consumption and desired versus undesired products",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Reactant-Equivalent Basis")
                            .font(.headline)

                        Text(
                            "X_A = (N_A0 − N_A)/N_A0"
                        )
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Each product amount is divided by its stoichiometric product yield to determine the corresponding reactant consumption."
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
                        Text("Reactant")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Initial Reactant Moles",
                            symbol: "N_A0",
                            unit: "mol",
                            placeholder: "Example: 100",
                            text: $initialReactantInput
                        )

                        EngineeringInputField(
                            title: "Final Reactant Moles",
                            symbol: "N_A",
                            unit: "mol",
                            placeholder: "Example: 20",
                            text: $finalReactantInput
                        )

                        Divider()

                        Text("Products")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Desired Product Moles",
                            symbol: "N_D",
                            unit: "mol",
                            placeholder: "Example: 60",
                            text: $desiredProductInput
                        )

                        EngineeringInputField(
                            title: "Undesired Product Moles",
                            symbol: "N_U",
                            unit: "mol",
                            placeholder: "Example: 10",
                            text: $undesiredProductInput
                        )

                        EngineeringInputField(
                            title:
                                "Desired Product per Reactant",
                            symbol: "ν_D",
                            unit: "mol/mol A",
                            placeholder: "Example: 1",
                            text:
                                $desiredStoichiometricYieldInput
                        )

                        EngineeringInputField(
                            title:
                                "Undesired Product per Reactant",
                            symbol: "ν_U",
                            unit: "mol/mol A",
                            placeholder: "Example: 0.5",
                            text:
                                $undesiredStoichiometricYieldInput
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
                                "Calculate Performance",
                            systemImage: "target",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
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
                                                "Desired Yield on Consumed A",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .desiredYieldOnConsumedFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Desired Selectivity Fraction",
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
                                                "Desired / Undesired Selectivity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .desiredToUndesiredSelectivityRatio
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Accounting Closure",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .accountingClosureFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Unaccounted A Consumption",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .unaccountedReactantConsumption
                                                ),
                                            unit: "mol A"
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
        .navigationTitle("Reaction Performance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialReactantMoles:
                        try InputValidator.parseNumber(
                            initialReactantInput,
                            fieldName:
                                "initial reactant moles"
                        ),
                    finalReactantMoles:
                        try InputValidator.parseNumber(
                            finalReactantInput,
                            fieldName:
                                "final reactant moles"
                        ),
                    desiredProductMoles:
                        try InputValidator.parseNumber(
                            desiredProductInput,
                            fieldName:
                                "desired product moles"
                        ),
                    undesiredProductMoles:
                        try InputValidator.parseNumber(
                            undesiredProductInput,
                            fieldName:
                                "undesired product moles"
                        ),
                    desiredProductStoichiometricYield:
                        try InputValidator.parseNumber(
                            desiredStoichiometricYieldInput,
                            fieldName:
                                "desired stoichiometric yield"
                        ),
                    undesiredProductStoichiometricYield:
                        try InputValidator.parseNumber(
                            undesiredStoichiometricYieldInput,
                            fieldName:
                                "undesired stoichiometric yield"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialReactantInput = "100"
        finalReactantInput = "20"
        desiredProductInput = "60"
        undesiredProductInput = "10"
        desiredStoichiometricYieldInput = "1"
        undesiredStoichiometricYieldInput = "0.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialReactantInput = ""
        finalReactantInput = ""
        desiredProductInput = ""
        undesiredProductInput = ""
        desiredStoichiometricYieldInput = ""
        undesiredStoichiometricYieldInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ConversionYieldSelectivityView()
    }
}
