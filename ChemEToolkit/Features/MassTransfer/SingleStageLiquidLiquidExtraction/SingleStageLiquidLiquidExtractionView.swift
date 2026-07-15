import SwiftUI

struct SingleStageLiquidLiquidExtractionView:
    View {

    @State
    private var raffinateFlowInput = "100"

    @State
    private var solventFlowInput = "50"

    @State
    private var feedRatioInput = "0.2"

    @State
    private var solventRatioInput = "0"

    @State
    private var distributionInput = "3"

    @State
    private var result:
        SingleStageLiquidLiquidExtractionResult?

    @State
    private var errorMessage = ""

    private let engine =
        SingleStageLiquidLiquidExtractionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.triangle.2.circlepath.circle.fill",
                    title:
                        "Single-Stage Liquid–Liquid Extraction",
                    subtitle:
                        "Solve one equilibrium contact between immiscible carrier phases",
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
            "Single-Stage Extraction"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text("One Equilibrium Stage")
                    .font(.headline)

                Text(
                    "F XF + S YS = F XR + S YE"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)

                Text("YE = D XR")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Carrier phases are treated as immiscible and their \
                    flow rates remain constant. Signed transfer preserves \
                    extraction and back-extraction directions.
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
            Text("Carrier Flow Rates")
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

            Divider()

            Text("Solute Ratios and Equilibrium")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Feed Solute Ratio",
                symbol: "XF",
                unit: "kg/kg",
                placeholder: "Example: 0.2",
                text: $feedRatioInput
            )

            EngineeringInputField(
                title:
                    "Entering-Solvent Solute Ratio",
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
                placeholder: "Example: 3",
                text: $distributionInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Solve Single Extraction Stage",
                systemImage:
                    "arrow.triangle.2.circlepath.circle.fill",
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
            SingleStageLiquidLiquidExtractionResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Raffinate Outlet Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .raffinateOutletSoluteRatio
                            ),
                        unit: "kg/kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Extract Outlet Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .extractOutletSoluteRatio
                            ),
                        unit: "kg/kg"
                    ),
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
                            "Transfer-Rate Magnitude",
                        value:
                            numberFormatter.format(
                                result
                                    .transferRateMagnitude
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Raffinate Removal",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .raffinateRemovalFraction
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
                        "Transfer Direction",
                        systemImage:
                            "arrow.triangle.2.circlepath.circle.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .directionDescription
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
        -> SingleStageLiquidLiquidExtractionInput {

        SingleStageLiquidLiquidExtractionInput(
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
            feedSoluteRatio:
                try InputValidator.parseNumber(
                    feedRatioInput,
                    fieldName:
                        "feed solute ratio"
                ),
            enteringSolventSoluteRatio:
                try InputValidator.parseNumber(
                    solventRatioInput,
                    fieldName:
                        "entering-solvent solute ratio"
                ),
            distributionCoefficient:
                try InputValidator.parseNumber(
                    distributionInput,
                    fieldName:
                        "distribution coefficient"
                )
        )
    }

    private func loadExample() {
        raffinateFlowInput = "100"
        solventFlowInput = "50"
        feedRatioInput = "0.2"
        solventRatioInput = "0"
        distributionInput = "3"
        clearResult()
    }

    private func resetInputs() {
        raffinateFlowInput = ""
        solventFlowInput = ""
        feedRatioInput = ""
        solventRatioInput = ""
        distributionInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SingleStageLiquidLiquidExtractionView()
    }
}
