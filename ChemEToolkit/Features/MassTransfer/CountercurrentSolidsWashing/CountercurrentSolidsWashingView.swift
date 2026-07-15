import SwiftUI

struct CountercurrentSolidsWashingView:
    View {

    @State
    private var insolubleSolidInput =
        "100"

    @State
    private var retainedSolventRatioInput =
        "0.5"

    @State
    private var freshWashFlowInput =
        "100"

    @State
    private var feedSoluteRatioInput =
        "0.2"

    @State
    private var freshWashRatioInput =
        "0"

    @State
    private var stageCountInput = "3"

    @State
    private var result:
        CountercurrentSolidsWashingResult?

    @State
    private var errorMessage = ""

    private let engine =
        CountercurrentSolidsWashingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right.circle.fill",
                    title:
                        "Countercurrent Solids Washing",
                    subtitle:
                        "Solve ideal washing-stage concentrations, recovery and final underflow loss",
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
            "Countercurrent Solids Washing"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Ideal Mixing–Settling Stages"
                )
                .font(.headline)

                Text(
                    "U Xi−1 + V Xi+1 = (U + V)Xi"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.48)
                .multilineTextAlignment(.center)

                Text("Washing factor = V/U")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Ratios are kg solute per kg solute-free solvent. \
                    The tridiagonal stage balances retain the physical \
                    countercurrent coupling between every washer.
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
            Text("Solids and Liquid Flows")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Insoluble-Solid Flow",
                symbol: "B",
                unit: "kg/h",
                placeholder: "Example: 100",
                text: $insolubleSolidInput
            )

            EngineeringInputField(
                title:
                    "Retained Solvent per Solid",
                symbol: "U/B",
                unit: "kg/kg solid",
                placeholder: "Example: 0.5",
                text:
                    $retainedSolventRatioInput
            )

            EngineeringInputField(
                title:
                    "Fresh Wash-Solvent Flow",
                symbol: "V",
                unit: "kg/h",
                placeholder: "Example: 100",
                text: $freshWashFlowInput
            )

            EngineeringInputField(
                title:
                    "Number of Ideal Stages",
                symbol: "N",
                unit: "stages",
                placeholder: "Example: 3",
                text: $stageCountInput
            )

            Divider()

            Text("Solute Ratios")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Feed Underflow Solute Ratio",
                symbol: "X0",
                unit: "kg/kg solvent",
                placeholder: "Example: 0.2",
                text: $feedSoluteRatioInput
            )

            EngineeringInputField(
                title:
                    "Fresh Wash Solute Ratio",
                symbol: "XW",
                unit: "kg/kg solvent",
                placeholder: "Example: 0",
                text: $freshWashRatioInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Solve Countercurrent Washers",
                systemImage:
                    "arrow.left.arrow.right.circle.fill",
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
            CountercurrentSolidsWashingResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Retained Solvent Flow",
                        value:
                            numberFormatter.format(
                                result
                                    .retainedSolventFlowRate
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Overflow Solvent Flow",
                        value:
                            numberFormatter.format(
                                result
                                    .overflowSolventFlowRate
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label: "Washing Factor",
                        value:
                            numberFormatter.format(
                                result.washingFactor
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Product Overflow Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .productOverflowSoluteRatio
                            ),
                        unit: "kg/kg solvent"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Final Underflow Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .finalUnderflowSoluteRatio
                            ),
                        unit: "kg/kg solvent"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Recovered Solute",
                        value:
                            numberFormatter.format(
                                result
                                    .recoveredSoluteInOverflow
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Residual Solute with Solids",
                        value:
                            numberFormatter.format(
                                result
                                    .residualSoluteWithWashedSolids
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solute Removal",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .soluteRemovalFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solute-Balance Residual",
                        value:
                            numberFormatter.format(
                                result
                                    .soluteBalanceResidual
                            ),
                        unit: "kg/h"
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
                        "Ideal Stage Profile",
                        systemImage:
                            "arrow.left.arrow.right.circle.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .stageSoluteRatios
                            .enumerated()
                            .map {
                                "Stage \($0.offset + 1): X = \(numberFormatter.format($0.element))"
                            }
                            .joined(separator: "\n")
                    )
                    .foregroundStyle(.secondary)

                    Text(result.modelName)
                        .fontWeight(.semibold)

                    Text(
                        result
                            .limitationDescription
                    )
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
        -> CountercurrentSolidsWashingInput {

        CountercurrentSolidsWashingInput(
            insolubleSolidFlowRate:
                try InputValidator.parseNumber(
                    insolubleSolidInput,
                    fieldName:
                        "insoluble-solid flow"
                ),
            retainedSolventPerInsolubleSolid:
                try InputValidator.parseNumber(
                    retainedSolventRatioInput,
                    fieldName:
                        "retained solvent ratio"
                ),
            freshWashSolventFlowRate:
                try InputValidator.parseNumber(
                    freshWashFlowInput,
                    fieldName:
                        "fresh wash-solvent flow"
                ),
            feedUnderflowSoluteRatio:
                try InputValidator.parseNumber(
                    feedSoluteRatioInput,
                    fieldName:
                        "feed underflow solute ratio"
                ),
            freshWashSoluteRatio:
                try InputValidator.parseNumber(
                    freshWashRatioInput,
                    fieldName:
                        "fresh wash solute ratio"
                ),
            numberOfIdealStages:
                try InputValidator.parseNumber(
                    stageCountInput,
                    fieldName:
                        "number of ideal stages"
                )
        )
    }

    private func loadExample() {
        insolubleSolidInput = "100"
        retainedSolventRatioInput = "0.5"
        freshWashFlowInput = "100"
        feedSoluteRatioInput = "0.2"
        freshWashRatioInput = "0"
        stageCountInput = "3"
        clearResult()
    }

    private func resetInputs() {
        insolubleSolidInput = ""
        retainedSolventRatioInput = ""
        freshWashFlowInput = ""
        feedSoluteRatioInput = ""
        freshWashRatioInput = ""
        stageCountInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CountercurrentSolidsWashingView()
    }
}
