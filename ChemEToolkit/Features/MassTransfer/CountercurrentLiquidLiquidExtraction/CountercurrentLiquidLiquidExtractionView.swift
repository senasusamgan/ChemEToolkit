import SwiftUI

struct CountercurrentLiquidLiquidExtractionView:
    View {

    @State
    private var raffinateFlowInput = "100"

    @State
    private var solventFlowInput = "50"

    @State
    private var distributionInput = "3"

    @State
    private var feedRatioInput = "0.2"

    @State
    private var targetRatioInput = "0.02"

    @State
    private var enteringSolventInput = "0"

    @State
    private var result:
        CountercurrentLiquidLiquidExtractionResult?

    @State
    private var errorMessage = ""

    private let engine =
        CountercurrentLiquidLiquidExtractionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.up.arrow.down.circle.fill",
                    title:
                        "Countercurrent Liquid–Liquid Extraction",
                    subtitle:
                        "Estimate ideal stages and achieved raffinate composition",
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
            "Countercurrent Extraction"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Countercurrent Extraction Factor"
                )
                .font(.headline)

                Text("E = D S / F")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )

                Text(
                    "r = (E − 1)/(Eᴺ⁺¹ − 1)"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )

                Text(
                    """
                    The Kremser-form extraction relation is applied to \
                    solute ratios shifted by the entering-solvent equilibrium \
                    composition. Ideal equilibrium stages are assumed.
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
            Text("Carrier Flow and Equilibrium")
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
                    "Solvent Carrier Flow",
                symbol: "S",
                unit: "kg/h",
                placeholder: "Example: 50",
                text: $solventFlowInput
            )

            EngineeringInputField(
                title:
                    "Distribution Coefficient",
                symbol: "D",
                unit: "—",
                placeholder: "Example: 3",
                text: $distributionInput
            )

            Divider()

            Text("Solute Specifications")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Feed Raffinate Ratio",
                symbol: "XF",
                unit: "kg/kg",
                placeholder: "Example: 0.2",
                text: $feedRatioInput
            )

            EngineeringInputField(
                title:
                    "Target Raffinate Ratio",
                symbol: "XR,target",
                unit: "kg/kg",
                placeholder: "Example: 0.02",
                text: $targetRatioInput
            )

            EngineeringInputField(
                title:
                    "Entering-Solvent Ratio",
                symbol: "YS,in",
                unit: "kg/kg",
                placeholder: "Example: 0",
                text: $enteringSolventInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Countercurrent Stages",
                systemImage:
                    "arrow.up.arrow.down.circle.fill",
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
            CountercurrentLiquidLiquidExtractionResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Extraction Factor",
                        value:
                            numberFormatter.format(
                                result.extractionFactor
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Continuous Ideal Stages",
                        value:
                            numberFormatter.format(
                                result
                                    .continuousIdealStageCount
                            ),
                        unit: "stages"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Required Whole Stages",
                        value:
                            String(
                                result
                                    .requiredWholeStageCount
                            ),
                        unit: "stages"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Equilibrium Raffinate Limit",
                        value:
                            numberFormatter.format(
                                result
                                    .equilibriumRaffinateLimit
                            ),
                        unit: "kg/kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Achieved Raffinate Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .achievedRaffinateSoluteRatio
                            ),
                        unit: "kg/kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solvent Outlet Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .solventOutletSoluteRatio
                            ),
                        unit: "kg/kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Target Removal",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .targetRemovalFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Achieved Removal",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .achievedRemovalFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solute Transfer Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .soluteTransferRate
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
                        "Stage Calculation Basis",
                        systemImage:
                            "arrow.up.arrow.down.circle.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .limitingCaseDescription
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
        -> CountercurrentLiquidLiquidExtractionInput {

        CountercurrentLiquidLiquidExtractionInput(
            raffinateCarrierFlowRate:
                try InputValidator.parseNumber(
                    raffinateFlowInput,
                    fieldName:
                        "raffinate carrier flow"
                ),
            solventCarrierFlowRate:
                try InputValidator.parseNumber(
                    solventFlowInput,
                    fieldName:
                        "solvent carrier flow"
                ),
            distributionCoefficient:
                try InputValidator.parseNumber(
                    distributionInput,
                    fieldName:
                        "distribution coefficient"
                ),
            feedSoluteRatio:
                try InputValidator.parseNumber(
                    feedRatioInput,
                    fieldName:
                        "feed raffinate ratio"
                ),
            targetRaffinateSoluteRatio:
                try InputValidator.parseNumber(
                    targetRatioInput,
                    fieldName:
                        "target raffinate ratio"
                ),
            enteringSolventSoluteRatio:
                try InputValidator.parseNumber(
                    enteringSolventInput,
                    fieldName:
                        "entering-solvent ratio"
                )
        )
    }

    private func loadExample() {
        raffinateFlowInput = "100"
        solventFlowInput = "50"
        distributionInput = "3"
        feedRatioInput = "0.2"
        targetRatioInput = "0.02"
        enteringSolventInput = "0"
        clearResult()
    }

    private func resetInputs() {
        raffinateFlowInput = ""
        solventFlowInput = ""
        distributionInput = ""
        feedRatioInput = ""
        targetRatioInput = ""
        enteringSolventInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CountercurrentLiquidLiquidExtractionView()
    }
}
