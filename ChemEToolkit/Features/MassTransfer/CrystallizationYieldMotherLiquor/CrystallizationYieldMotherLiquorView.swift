import SwiftUI

struct CrystallizationYieldMotherLiquorView:
    View {

    @State
    private var feedMassInput =
        "1000"

    @State
    private var feedSoluteFractionInput =
        "0.3"

    @State
    private var evaporatedSolventInput =
        "100"

    @State
    private var finalSolubilityInput =
        "0.25"

    @State
    private var crystalSoluteFractionInput =
        "1"

    @State
    private var result:
        CrystallizationYieldMotherLiquorResult?

    @State
    private var errorMessage = ""

    private let engine =
        CrystallizationYieldMotherLiquorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "snowflake",
                    title:
                        "Crystallization Yield & Mother Liquor",
                    subtitle:
                        "Calculate crystal recovery, hydrate solvent and saturated mother liquor",
                    tint: .blue
                )

                formulaCard

                CalculatorCard {
                    calculatorContent
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
        .navigationTitle(
            "Crystallization Yield"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Solute–Solvent Balance"
                )
                .font(.headline)

                Text(
                    "A0 = pC + Xs WML"
                )
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )

                Text(
                    "W0 − E = (1 − p)C + WML"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.5)

                Text(
                    """
                    Solubility Xs is kg solute per kg solvent. \
                    Crystal solute fraction p = 1 represents pure \
                    anhydrous crystals; p < 1 represents solvent-containing crystals.
                    """
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
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Feed Solution")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Feed Solution Mass",
                symbol: "M0",
                unit: "kg",
                placeholder: "Example: 1000",
                text: $feedMassInput
            )

            EngineeringInputField(
                title:
                    "Feed Solute Mass Fraction",
                symbol: "w0",
                unit: "—",
                placeholder: "Example: 0.3",
                text:
                    $feedSoluteFractionInput
            )

            Divider()

            Text("Final Crystallization State")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Evaporated Solvent Mass",
                symbol: "E",
                unit: "kg",
                placeholder: "Example: 100",
                text:
                    $evaporatedSolventInput
            )

            EngineeringInputField(
                title:
                    "Final Solubility Ratio",
                symbol: "Xs",
                unit: "kg solute/kg solvent",
                placeholder: "Example: 0.25",
                text:
                    $finalSolubilityInput
            )

            EngineeringInputField(
                title:
                    "Crystal Solute Mass Fraction",
                symbol: "p",
                unit: "—",
                placeholder:
                    "1 pure; below 1 hydrate/solvate",
                text:
                    $crystalSoluteFractionInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Crystal Yield",
                systemImage: "snowflake",
                action: calculate
            )

            if let result {
                resultSection(result)
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private func resultSection(
        _ result:
            CrystallizationYieldMotherLiquorResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Supersaturation Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .supersaturationRatio
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label: "Crystal Mass",
                        value:
                            numberFormatter.format(
                                result.crystalMass
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Crystal Solute Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .crystalSoluteMass
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Crystal Solvent Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .crystalSolventMass
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Mother-Liquor Solvent",
                        value:
                            numberFormatter.format(
                                result
                                    .motherLiquorSolventMass
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Mother-Liquor Solute",
                        value:
                            numberFormatter.format(
                                result
                                    .motherLiquorSoluteMass
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Mother-Liquor Total Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .motherLiquorTotalMass
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solute Recovery",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .soluteRecoveryFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Crystal Yield on Feed",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .crystalYieldOnFeed
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Mass-Balance Residual",
                        value:
                            numberFormatter.format(
                                result
                                    .totalMassBalanceResidual
                            ),
                        unit: "kg"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        result.phaseState.title,
                        systemImage: "snowflake"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result.stateDescription
                    )
                    .fontWeight(.semibold)

                    Text(result.modelName)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> CrystallizationYieldMotherLiquorInput {

        CrystallizationYieldMotherLiquorInput(
            feedSolutionMass:
                try InputValidator.parseNumber(
                    feedMassInput,
                    fieldName:
                        "feed solution mass"
                ),
            feedSoluteMassFraction:
                try InputValidator.parseNumber(
                    feedSoluteFractionInput,
                    fieldName:
                        "feed solute mass fraction"
                ),
            evaporatedSolventMass:
                try InputValidator.parseNumber(
                    evaporatedSolventInput,
                    fieldName:
                        "evaporated solvent mass"
                ),
            finalSolubilityRatio:
                try InputValidator.parseNumber(
                    finalSolubilityInput,
                    fieldName:
                        "final solubility ratio"
                ),
            crystalSoluteMassFraction:
                try InputValidator.parseNumber(
                    crystalSoluteFractionInput,
                    fieldName:
                        "crystal solute mass fraction"
                )
        )
    }

    private func loadExample() {
        feedMassInput = "1000"
        feedSoluteFractionInput = "0.3"
        evaporatedSolventInput = "100"
        finalSolubilityInput = "0.25"
        crystalSoluteFractionInput = "1"
        clearResult()
    }

    private func resetInputs() {
        feedMassInput = ""
        feedSoluteFractionInput = ""
        evaporatedSolventInput = ""
        finalSolubilityInput = ""
        crystalSoluteFractionInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CrystallizationYieldMotherLiquorView()
    }
}
