import SwiftUI

struct ExtractionDistributionSelectivityView:
    View {

    @State private var feedFlowInput =
        "100"

    @State private var solventFlowInput =
        "50"

    @State private var targetCoefficientInput =
        "4.0"

    @State private var impurityCoefficientInput =
        "0.5"

    @State private var result:
        ExtractionDistributionSelectivityResult?

    @State private var errorMessage = ""

    private let engine =
        ExtractionDistributionSelectivityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right.circle.fill",
                    title:
                        "Extraction Distribution & Selectivity",
                    subtitle:
                        "Compare target and impurity extraction into one solvent",
                    tint: .purple
                )

                CalculatorInfoCard(
                    tint: .purple
                ) {
                    Text(
                        "Higher target-to-impurity distribution selectivity indicates a more selective extraction solvent."
                    )
                    .foregroundStyle(
                        .secondary
                    )
                    .multilineTextAlignment(
                        .center
                    )
                    .frame(
                        maxWidth:
                            .infinity
                    )
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing:
                            AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title:
                                "Feed Carrier Flow",
                            symbol: "F",
                            unit: "kg/h",
                            placeholder:
                                "100",
                            text:
                                $feedFlowInput
                        )

                        EngineeringInputField(
                            title:
                                "Solvent Carrier Flow",
                            symbol: "S",
                            unit: "kg/h",
                            placeholder:
                                "50",
                            text:
                                $solventFlowInput
                        )

                        EngineeringInputField(
                            title:
                                "Target Distribution Coefficient",
                            symbol:
                                "K_target",
                            unit: "—",
                            placeholder:
                                "4.0",
                            text:
                                $targetCoefficientInput
                        )

                        EngineeringInputField(
                            title:
                                "Impurity Distribution Coefficient",
                            symbol:
                                "K_impurity",
                            unit: "—",
                            placeholder:
                                "0.5",
                            text:
                                $impurityCoefficientInput
                        )

                        HStack(
                            spacing:
                                AppSpacing.medium
                        ) {
                            Button(
                                action:
                                    loadExample
                            ) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role:
                                    .destructive,
                                action:
                                    resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage:
                                        "trash"
                                )
                            }
                        }
                        .buttonStyle(
                            .bordered
                        )

                        PrimaryActionButton(
                            title:
                                "Calculate",
                            systemImage:
                                "arrow.left.arrow.right.circle.fill",
                            action:
                                calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label:
                                            "Solvent/Feed Ratio",
                                        value:
                                            numberFormatter.format(
                                                result.solventToFeedRatio
                                            ),
                                        unit:
                                            "—"
                                    ),
                                    .init(
                                        label:
                                            "Distribution Selectivity",
                                        value:
                                            numberFormatter.format(
                                                result.distributionSelectivity
                                            ),
                                        unit:
                                            "—"
                                    ),
                                    .init(
                                        label:
                                            "Target Extraction",
                                        value:
                                            numberFormatter.format(
                                                100
                                                * result.targetExtractedFraction
                                            ),
                                        unit:
                                            "%"
                                    ),
                                    .init(
                                        label:
                                            "Impurity Extraction",
                                        value:
                                            numberFormatter.format(
                                                100
                                                * result.impurityExtractedFraction
                                            ),
                                        unit:
                                            "%"
                                    ),
                                    .init(
                                        label:
                                            "Extracted-Fraction Selectivity",
                                        value:
                                            numberFormatter.format(
                                                result.extractedFractionSelectivity
                                            ),
                                        unit:
                                            "—"
                                    ),
                                    .init(
                                        label:
                                            "Assessment",
                                        value:
                                            result.separationDescription,
                                        unit:
                                            "—"
                                    )
                                ],
                                tint:
                                    .purple
                            )

                            CalculatorInfoCard(
                                tint:
                                    .purple
                            ) {
                                VStack(
                                    alignment:
                                        .leading,
                                    spacing:
                                        AppSpacing.small
                                ) {
                                    Text(
                                        result.modelName
                                    )
                                    .font(
                                        .headline
                                    )

                                    Divider()

                                    Text(
                                        result.limitationDescription
                                    )
                                    .foregroundStyle(
                                        .secondary
                                    )
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(
                                message:
                                    errorMessage
                            )
                        }
                    }
                }
            }
            .frame(
                maxWidth:
                    .infinity
            )
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
            "Extraction Distribution & Selectivity"
        )
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result =
                try engine.calculate(
                    .init(
                        feedCarrierFlow:
                            try InputValidator.parseNumber(
                                feedFlowInput,
                                fieldName:
                                    "feed carrier flow"
                            ),
                        solventCarrierFlow:
                            try InputValidator.parseNumber(
                                solventFlowInput,
                                fieldName:
                                    "solvent carrier flow"
                            ),
                        targetDistributionCoefficient:
                            try InputValidator.parseNumber(
                                targetCoefficientInput,
                                fieldName:
                                    "target distribution coefficient"
                            ),
                        impurityDistributionCoefficient:
                            try InputValidator.parseNumber(
                                impurityCoefficientInput,
                                fieldName:
                                    "impurity distribution coefficient"
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
        solventFlowInput = "50"
        targetCoefficientInput =
            "4.0"
        impurityCoefficientInput =
            "0.5"

        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedFlowInput = ""
        solventFlowInput = ""
        targetCoefficientInput = ""
        impurityCoefficientInput = ""

        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ExtractionDistributionSelectivityView()
    }
}
