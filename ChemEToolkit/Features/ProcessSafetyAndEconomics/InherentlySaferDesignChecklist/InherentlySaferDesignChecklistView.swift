import SwiftUI

struct InherentlySaferDesignChecklistView:
    View {

    @State private var minimizeInput = "3"
    @State private var substituteInput = "2"
    @State private var moderateInput = "4"
    @State private var simplifyInput = "3"
    @State private var confidenceInput = "4"

    @State private var result:
        InherentlySaferDesignChecklistResult?

    @State private var errorMessage = ""

    private let engine =
        InherentlySaferDesignChecklistEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "shield.lefthalf.filled",
                    title: "Inherently Safer Design",
                    subtitle: "Screen minimize, substitute, moderate and simplify opportunities",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Rate how strongly the design addresses the four core inherently safer design principles.")
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
                            title: "Minimize Rating",
                            symbol: "M₁",
                            unit: "0–5",
                            placeholder: "3",
                            text: $minimizeInput
                        )

                        EngineeringInputField(
                            title: "Substitute Rating",
                            symbol: "M₂",
                            unit: "0–5",
                            placeholder: "2",
                            text: $substituteInput
                        )

                        EngineeringInputField(
                            title: "Moderate Rating",
                            symbol: "M₃",
                            unit: "0–5",
                            placeholder: "4",
                            text: $moderateInput
                        )

                        EngineeringInputField(
                            title: "Simplify Rating",
                            symbol: "M₄",
                            unit: "0–5",
                            placeholder: "3",
                            text: $simplifyInput
                        )

                        EngineeringInputField(
                            title: "Implementation Confidence",
                            symbol: "C",
                            unit: "0–5",
                            placeholder: "4",
                            text: $confidenceInput
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
                            systemImage: "shield.lefthalf.filled",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Principle Score",
                                        value: numberFormatter.format(result.principleScore),
                                        unit: "of 20"
                                    ),
.init(
                                        label: "Coverage",
                                        value: numberFormatter.format(100 * result.coverageFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Confidence-Adjusted Score",
                                        value: numberFormatter.format(result.confidenceAdjustedScore),
                                        unit: "of 20"
                                    ),
.init(
                                        label: "Weakest Principle",
                                        value: result.weakestPrinciple,
                                        unit: "—"
                                    ),
.init(
                                        label: "Maturity Band",
                                        value: result.maturityBand,
                                        unit: "—"
                                    ),
.init(
                                        label: "Priority",
                                        value: result.priorityRecommendation,
                                        unit: "—"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Inherently Safer Design")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    minimizeRating:
                        try InputValidator.parseNumber(
                            minimizeInput,
                            fieldName:
                                "minimize rating"
                        ),
                    substituteRating:
                        try InputValidator.parseNumber(
                            substituteInput,
                            fieldName:
                                "substitute rating"
                        ),
                    moderateRating:
                        try InputValidator.parseNumber(
                            moderateInput,
                            fieldName:
                                "moderate rating"
                        ),
                    simplifyRating:
                        try InputValidator.parseNumber(
                            simplifyInput,
                            fieldName:
                                "simplify rating"
                        ),
                    implementationConfidence:
                        try InputValidator.parseNumber(
                            confidenceInput,
                            fieldName:
                                "implementation confidence"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        minimizeInput = "3"
        substituteInput = "2"
        moderateInput = "4"
        simplifyInput = "3"
        confidenceInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        minimizeInput = ""
        substituteInput = ""
        moderateInput = ""
        simplifyInput = ""
        confidenceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        InherentlySaferDesignChecklistView()
    }
}
