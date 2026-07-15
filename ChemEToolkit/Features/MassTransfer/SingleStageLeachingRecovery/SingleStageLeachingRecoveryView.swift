import SwiftUI

struct SingleStageLeachingRecoveryView:
    View {

    @State
    private var insolubleSolidInput =
        "100"

    @State
    private var solubleSoluteInput =
        "20"

    @State
    private var solventFlowInput =
        "100"

    @State
    private var retentionRatioInput =
        "0.4"

    @State
    private var result:
        SingleStageLeachingRecoveryResult?

    @State
    private var errorMessage = ""

    private let engine =
        SingleStageLeachingRecoveryEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "cube.fill",
                    title:
                        "Single-Stage Leaching & Recovery",
                    subtitle:
                        "Calculate ideal extract recovery and solute retained with insoluble solids",
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
            "Single-Stage Leaching"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Complete Dissolution + Ideal Separation"
                )
                .font(.headline)

                Text("X = A / S")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )

                Text(
                    "Recovered A = (S − UB)X"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)

                Text(
                    """
                    X is kg solute per kg solute-free solvent. \
                    The insoluble underflow retains U kg solvent per \
                    kg insoluble solid, at the same composition as the overflow.
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
            Text("Solid Feed")
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
                    "Soluble-Solute Flow",
                symbol: "A",
                unit: "kg/h",
                placeholder: "Example: 20",
                text: $solubleSoluteInput
            )

            Divider()

            Text("Solvent and Underflow")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Pure-Solvent Flow",
                symbol: "S",
                unit: "kg/h",
                placeholder: "Example: 100",
                text: $solventFlowInput
            )

            EngineeringInputField(
                title:
                    "Retained Solvent per Insoluble Solid",
                symbol: "U",
                unit: "kg/kg solid",
                placeholder: "Example: 0.4",
                text: $retentionRatioInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Leaching Recovery",
                systemImage: "cube.fill",
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
            SingleStageLeachingRecoveryResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Equilibrium Solute Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .equilibriumSoluteRatio
                            ),
                        unit: "kg/kg solvent"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Retained Solvent",
                        value:
                            numberFormatter.format(
                                result
                                    .retainedSolventFlowRate
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Overflow Solvent",
                        value:
                            numberFormatter.format(
                                result
                                    .overflowSolventFlowRate
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Recovered Solute",
                        value:
                            numberFormatter.format(
                                result
                                    .soluteRecoveredInOverflow
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solute Retained in Underflow",
                        value:
                            numberFormatter.format(
                                result
                                    .soluteRetainedWithUnderflow
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label: "Solute Recovery",
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
                            "Overflow Solution Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .overflowSolutionMassFlowRate
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Underflow Total Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .underflowTotalMassFlowRate
                            ),
                        unit: "kg/h"
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
                        "Leaching Model",
                        systemImage: "cube.fill"
                    )
                    .font(.headline)

                    Divider()

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
        -> SingleStageLeachingRecoveryInput {

        SingleStageLeachingRecoveryInput(
            insolubleSolidFlowRate:
                try InputValidator.parseNumber(
                    insolubleSolidInput,
                    fieldName:
                        "insoluble-solid flow"
                ),
            solubleSoluteFlowRate:
                try InputValidator.parseNumber(
                    solubleSoluteInput,
                    fieldName:
                        "soluble-solute flow"
                ),
            pureSolventFlowRate:
                try InputValidator.parseNumber(
                    solventFlowInput,
                    fieldName:
                        "pure-solvent flow"
                ),
            retainedSolventPerInsolubleSolid:
                try InputValidator.parseNumber(
                    retentionRatioInput,
                    fieldName:
                        "retained solvent ratio"
                )
        )
    }

    private func loadExample() {
        insolubleSolidInput = "100"
        solubleSoluteInput = "20"
        solventFlowInput = "100"
        retentionRatioInput = "0.4"
        clearResult()
    }

    private func resetInputs() {
        insolubleSolidInput = ""
        solubleSoluteInput = ""
        solventFlowInput = ""
        retentionRatioInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SingleStageLeachingRecoveryView()
    }
}
