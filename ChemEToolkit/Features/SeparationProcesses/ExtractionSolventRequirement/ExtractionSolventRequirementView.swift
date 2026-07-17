import SwiftUI

struct ExtractionSolventRequirementView:
    View {

    @State private var feedFlowInput = "100"
    @State private var feedFractionInput = "0.10"
    @State private var coefficientInput = "2.0"
    @State private var removalInput = "0.80"

    @State private var result:
        ExtractionSolventRequirementResult?

    @State private var errorMessage = ""

    private let engine =
        ExtractionSolventRequirementEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.triangle.fill",
                    title: "Extraction Solvent Requirement",
                    subtitle: "Size fresh solvent flow for a target single-stage removal",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The target removal is achieved in one ideal equilibrium contact.")
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
                            title: "Feed Solute Fraction",
                            symbol: "x_F",
                            unit: "—",
                            placeholder: "0.10",
                            text: $feedFractionInput
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
                            placeholder: "0.80",
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
                            systemImage: "drop.triangle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Required Solvent Flow",
                                        value: numberFormatter.format(result.requiredSolventFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Solvent/Feed Ratio",
                                        value: numberFormatter.format(result.solventToFeedRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Extraction Factor",
                                        value: numberFormatter.format(result.extractionFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Raffinate Solute Fraction",
                                        value: numberFormatter.format(result.raffinateSoluteFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Extract Solute Fraction",
                                        value: numberFormatter.format(result.extractSoluteFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Solute Extracted",
                                        value: numberFormatter.format(result.soluteExtractedFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Solute Remaining",
                                        value: numberFormatter.format(result.soluteRemainingFlow),
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
        .navigationTitle("Extraction Solvent Requirement")
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
                    feedSoluteFraction:
                        try InputValidator.parseNumber(
                            feedFractionInput,
                            fieldName:
                                "feed solute fraction"
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
        feedFractionInput = "0.10"
        coefficientInput = "2.0"
        removalInput = "0.80"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedFlowInput = ""
        feedFractionInput = ""
        coefficientInput = ""
        removalInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ExtractionSolventRequirementView()
    }
}
