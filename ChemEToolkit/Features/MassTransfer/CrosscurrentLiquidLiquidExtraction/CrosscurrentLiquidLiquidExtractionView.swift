import SwiftUI

struct CrosscurrentLiquidLiquidExtractionView:
    View {

    @State
    private var raffinateFlowInput = "100"

    @State
    private var totalSolventInput = "100"

    @State
    private var feedRatioInput = "0.2"

    @State
    private var solventRatioInput = "0"

    @State
    private var distributionInput = "2"

    @State
    private var stageCountInput = "3"

    @State
    private var result:
        CrosscurrentLiquidLiquidExtractionResult?

    @State
    private var errorMessage = ""

    private let engine =
        CrosscurrentLiquidLiquidExtractionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "square.stack.3d.down.right",
                    title:
                        "Crosscurrent Liquid–Liquid Extraction",
                    subtitle:
                        "Evaluate repeated equilibrium contacts with equal fresh-solvent portions",
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
            "Crosscurrent Extraction"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Equal Fresh Solvent per Stage"
                )
                .font(.headline)

                Text(
                    "Xj = [F Xj−1 + Sj YS] / [F + D Sj]"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.5)

                Text(
                    "Sj = Stotal / N"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )

                Text(
                    """
                    Each stage receives a new equal portion of solvent. \
                    Carrier phases are immiscible, flow rates are constant \
                    and every contact reaches linear equilibrium.
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
            Text("Carrier Flow and Staging")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Raffinate Carrier Flow",
                symbol: "F",
                unit: "kg/h",
                placeholder: "Example: 100",
                text: $raffinateFlowInput
            )

            EngineeringInputField(
                title:
                    "Total Fresh Solvent Flow",
                symbol: "Stotal",
                unit: "kg/h",
                placeholder: "Example: 100",
                text: $totalSolventInput
            )

            EngineeringInputField(
                title:
                    "Number of Stages",
                symbol: "N",
                unit: "stages",
                placeholder: "Example: 3",
                text: $stageCountInput
            )

            Divider()

            Text("Solute Ratios and Equilibrium")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Feed Solute Ratio",
                symbol: "X0",
                unit: "kg/kg",
                placeholder: "Example: 0.2",
                text: $feedRatioInput
            )

            EngineeringInputField(
                title:
                    "Fresh-Solvent Solute Ratio",
                symbol: "YS",
                unit: "kg/kg",
                placeholder: "Example: 0",
                text: $solventRatioInput
            )

            EngineeringInputField(
                title:
                    "Distribution Coefficient",
                symbol: "D",
                unit: "—",
                placeholder: "Example: 2",
                text: $distributionInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Crosscurrent Extraction",
                systemImage:
                    "square.stack.3d.down.right",
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
            CrosscurrentLiquidLiquidExtractionResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Solvent per Stage",
                        value:
                            numberFormatter.format(
                                result
                                    .solventFlowPerStage
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Extraction Factor per Stage",
                        value:
                            numberFormatter.format(
                                result
                                    .extractionFactorPerStage
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Final Raffinate Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .finalRaffinateSoluteRatio
                            ),
                        unit: "kg/kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Final-Stage Extract Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .finalStageExtractSoluteRatio
                            ),
                        unit: "kg/kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solute Remaining",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .soluteRemainingFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Overall Removal",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .overallRemovalFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Solute Transfer",
                        value:
                            numberFormatter.format(
                                result
                                    .totalTransferRate
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
                        "Stage Profile",
                        systemImage:
                            "square.stack.3d.down.right"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .raffinateRatiosByStage
                            .enumerated()
                            .map {
                                "Stage \($0.offset + 1): X = \(numberFormatter.format($0.element))"
                            }
                            .joined(separator: "\n")
                    )
                    .foregroundStyle(.secondary)

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
        -> CrosscurrentLiquidLiquidExtractionInput {

        CrosscurrentLiquidLiquidExtractionInput(
            raffinateCarrierFlowRate:
                try InputValidator.parseNumber(
                    raffinateFlowInput,
                    fieldName:
                        "raffinate carrier flow"
                ),
            totalFreshSolventFlowRate:
                try InputValidator.parseNumber(
                    totalSolventInput,
                    fieldName:
                        "total fresh solvent flow"
                ),
            feedSoluteRatio:
                try InputValidator.parseNumber(
                    feedRatioInput,
                    fieldName:
                        "feed solute ratio"
                ),
            freshSolventSoluteRatio:
                try InputValidator.parseNumber(
                    solventRatioInput,
                    fieldName:
                        "fresh-solvent solute ratio"
                ),
            distributionCoefficient:
                try InputValidator.parseNumber(
                    distributionInput,
                    fieldName:
                        "distribution coefficient"
                ),
            numberOfStages:
                try InputValidator.parseNumber(
                    stageCountInput,
                    fieldName:
                        "number of stages"
                )
        )
    }

    private func loadExample() {
        raffinateFlowInput = "100"
        totalSolventInput = "100"
        feedRatioInput = "0.2"
        solventRatioInput = "0"
        distributionInput = "2"
        stageCountInput = "3"
        clearResult()
    }

    private func resetInputs() {
        raffinateFlowInput = ""
        totalSolventInput = ""
        feedRatioInput = ""
        solventRatioInput = ""
        distributionInput = ""
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
        CrosscurrentLiquidLiquidExtractionView()
    }
}
