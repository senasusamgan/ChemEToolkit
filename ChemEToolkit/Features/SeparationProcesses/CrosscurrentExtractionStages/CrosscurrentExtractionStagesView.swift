import SwiftUI

struct CrosscurrentExtractionStagesView:
    View {

    @State private var feedFlowInput = "100"
    @State private var solventInput = "25"
    @State private var coefficientInput = "2.0"
    @State private var removalInput = "0.90"

    @State private var result:
        CrosscurrentExtractionStagesResult?

    @State private var errorMessage = ""

    private let engine =
        CrosscurrentExtractionStagesEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.branch",
                    title: "Crosscurrent Extraction Stages",
                    subtitle: "Estimate equal-fresh-solvent extraction stages",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Each equilibrium stage receives the same fresh solvent flow.")
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
                            title: "Feed Carrier Flow",
                            symbol: "F",
                            unit: "kg/h",
                            placeholder: "100",
                            text: $feedFlowInput
                        )

                        EngineeringInputField(
                            title: "Fresh Solvent per Stage",
                            symbol: "S_stage",
                            unit: "kg/h",
                            placeholder: "25",
                            text: $solventInput
                        )

                        EngineeringInputField(
                            title: "Distribution Coefficient",
                            symbol: "K_D",
                            unit: "—",
                            placeholder: "2.0",
                            text: $coefficientInput
                        )

                        EngineeringInputField(
                            title: "Target Removal Fraction",
                            symbol: "R",
                            unit: "—",
                            placeholder: "0.90",
                            text: $removalInput
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
                            systemImage: "arrow.triangle.branch",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Extraction Factor per Stage",
                                        value: numberFormatter.format(result.extractionFactorPerStage),
                                        unit: "—"
                                    ),
.init(
                                        label: "Single-Stage Fraction Remaining",
                                        value: numberFormatter.format(result.singleStageFractionRemaining),
                                        unit: "—"
                                    ),
.init(
                                        label: "Continuous Stage Estimate",
                                        value: numberFormatter.format(result.continuousStageEstimate),
                                        unit: "stages"
                                    ),
.init(
                                        label: "Required Whole Stages",
                                        value: String(result.requiredWholeStages),
                                        unit: "stages"
                                    ),
.init(
                                        label: "Whole-Stage Removal",
                                        value: numberFormatter.format(100 * result.achievedRemovalAtWholeStages),
                                        unit: "%"
                                    ),
.init(
                                        label: "Total Fresh Solvent",
                                        value: numberFormatter.format(result.totalFreshSolvent),
                                        unit: "kg/h"
                                    )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
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
        .navigationTitle("Crosscurrent Extraction Stages")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedCarrierFlow:
                        try InputValidator.parseNumber(
                            feedFlowInput,
                            fieldName:
                                "feed carrier flow"
                        ),
                    freshSolventPerStage:
                        try InputValidator.parseNumber(
                            solventInput,
                            fieldName:
                                "fresh solvent per stage"
                        ),
                    distributionCoefficient:
                        try InputValidator.parseNumber(
                            coefficientInput,
                            fieldName:
                                "distribution coefficient"
                        ),
                    targetRemovalFraction:
                        try InputValidator.parseNumber(
                            removalInput,
                            fieldName:
                                "target removal fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedFlowInput = "100"
        solventInput = "25"
        coefficientInput = "2.0"
        removalInput = "0.90"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedFlowInput = ""
        solventInput = ""
        coefficientInput = ""
        removalInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CrosscurrentExtractionStagesView()
    }
}
