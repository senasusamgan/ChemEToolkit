import SwiftUI

struct ALARPGrossDisproportionScreeningView:
    View {

    @State private var costInput = "1500000"
    @State private var benefitInput = "200000"
    @State private var lifeInput = "10"
    @State private var discountInput = "0.08"
    @State private var factorInput = "3"

    @State private var result:
        ALARPGrossDisproportionScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        ALARPGrossDisproportionScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scale.3d",
                    title: "ALARP Gross Disproportion",
                    subtitle: "Screen measure cost against discounted risk-reduction benefit",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The measure cost is compared with discounted avoided loss multiplied by a user-entered gross-disproportion factor.")
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
                            title: "Risk-Reduction Measure Cost",
                            symbol: "C_m",
                            unit: "currency",
                            placeholder: "1500000",
                            text: $costInput
                        )

                        EngineeringInputField(
                            title: "Annualized Loss Reduction",
                            symbol: "ΔALE",
                            unit: "currency/year",
                            placeholder: "200000",
                            text: $benefitInput
                        )

                        EngineeringInputField(
                            title: "Project Life",
                            symbol: "n",
                            unit: "years",
                            placeholder: "10",
                            text: $lifeInput
                        )

                        EngineeringInputField(
                            title: "Discount Rate",
                            symbol: "i",
                            unit: "fraction/year",
                            placeholder: "0.08",
                            text: $discountInput
                        )

                        EngineeringInputField(
                            title: "Gross-Disproportion Factor",
                            symbol: "GDF",
                            unit: "—",
                            placeholder: "3",
                            text: $factorInput
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
                            systemImage: "scale.3d",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "PV of Risk-Reduction Benefit",
                                        value: numberFormatter.format(result.presentValueOfRiskReductionBenefit),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Adjusted Cost Threshold",
                                        value: numberFormatter.format(result.adjustedReasonableCostThreshold),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Cost / Benefit",
                                        value: numberFormatter.format(result.costToBenefitRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Cost / Adjusted Threshold",
                                        value: numberFormatter.format(result.costToAdjustedThresholdRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Grossly Disproportionate",
                                        value: result.measureCostIsGrosslyDisproportionate ? "Yes" : "No",
                                        unit: "—"
                                    ),
.init(
                                        label: "Screening Recommendation",
                                        value: result.screeningRecommendation,
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
        .navigationTitle("ALARP Gross Disproportion")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    riskReductionMeasureCost:
                        try InputValidator.parseNumber(
                            costInput,
                            fieldName:
                                "risk-reduction measure cost"
                        ),
                    annualizedLossReduction:
                        try InputValidator.parseNumber(
                            benefitInput,
                            fieldName:
                                "annualized loss reduction"
                        ),
                    projectLifeYears:
                        try InputValidator.parseNumber(
                            lifeInput,
                            fieldName:
                                "project life"
                        ),
                    discountRateFraction:
                        try InputValidator.parseNumber(
                            discountInput,
                            fieldName:
                                "discount rate"
                        ),
                    grossDisproportionFactor:
                        try InputValidator.parseNumber(
                            factorInput,
                            fieldName:
                                "gross-disproportion factor"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        costInput = "1500000"
        benefitInput = "200000"
        lifeInput = "10"
        discountInput = "0.08"
        factorInput = "3"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        costInput = ""
        benefitInput = ""
        lifeInput = ""
        discountInput = ""
        factorInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ALARPGrossDisproportionScreeningView()
    }
}
