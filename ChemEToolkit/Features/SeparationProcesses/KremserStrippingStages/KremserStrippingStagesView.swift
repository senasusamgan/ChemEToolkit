import SwiftUI

struct KremserStrippingStagesView:
    View {

    @State private var factorInput = "1.8"
    @State private var removalInput = "0.90"

    @State private var result:
        KremserStrippingStagesResult?

    @State private var errorMessage = ""

    private let engine =
        KremserStrippingStagesEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.stack.3d.up.left.fill",
                    title: "Kremser Stripping Stages",
                    subtitle: "Estimate ideal stages for liquid-solute removal",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The target liquid-solute removal must be entered as a fraction.")
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
                            title: "Stripping Factor",
                            symbol: "S",
                            unit: "—",
                            placeholder: "1.8",
                            text: $factorInput
                        )

                        EngineeringInputField(
                            title: "Target Liquid-Solute Removal",
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
                            systemImage: "square.stack.3d.up.left.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
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
                                        label: "Fraction Remaining",
                                        value: numberFormatter.format(result.fractionRemaining),
                                        unit: "—"
                                    ),
.init(
                                        label: "Whole-Stage Removal",
                                        value: numberFormatter.format(100 * result.achievedRemovalAtWholeStages),
                                        unit: "%"
                                    ),
.init(
                                        label: "Removal Margin",
                                        value: numberFormatter.format(100 * result.stageMargin),
                                        unit: "percentage points"
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
        .navigationTitle("Kremser Stripping Stages")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    strippingFactor:
                        try InputValidator.parseNumber(
                            factorInput,
                            fieldName:
                                "stripping factor"
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
        factorInput = "1.8"
        removalInput = "0.90"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        factorInput = ""
        removalInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        KremserStrippingStagesView()
    }
}
