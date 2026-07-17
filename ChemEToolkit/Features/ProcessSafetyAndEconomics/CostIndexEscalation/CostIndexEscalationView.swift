import SwiftUI

struct CostIndexEscalationView:
    View {

    @State private var baseCostInput = "1000000"
    @State private var baseIndexInput = "600"
    @State private var targetIndexInput = "750"
    @State private var yearsInput = "5"

    @State private var result:
        CostIndexEscalationResult?

    @State private var errorMessage = ""

    private let engine =
        CostIndexEscalationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "calendar",
                    title: "Cost Index Escalation",
                    subtitle: "Convert a historical estimate to a target cost-index period",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("Cost indices update the price level of a comparable estimate without changing its technical scope.")
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
                            title: "Base Cost",
                            symbol: "C₁",
                            unit: "currency",
                            placeholder: "1000000",
                            text: $baseCostInput
                        )

                        EngineeringInputField(
                            title: "Base Cost Index",
                            symbol: "I₁",
                            unit: "index",
                            placeholder: "600",
                            text: $baseIndexInput
                        )

                        EngineeringInputField(
                            title: "Target Cost Index",
                            symbol: "I₂",
                            unit: "index",
                            placeholder: "750",
                            text: $targetIndexInput
                        )

                        EngineeringInputField(
                            title: "Elapsed Time",
                            symbol: "Δt",
                            unit: "years",
                            placeholder: "5",
                            text: $yearsInput
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
                            systemImage: "calendar",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Cost-Index Ratio",
                                        value: numberFormatter.format(result.costIndexRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Escalated Cost",
                                        value: numberFormatter.format(result.escalatedCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Absolute Cost Change",
                                        value: numberFormatter.format(result.absoluteCostChange),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Total Escalation",
                                        value: numberFormatter.format(100 * result.totalEscalationFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Compound Annual Rate",
                                        value: numberFormatter.format(100 * result.compoundAnnualEscalationRate),
                                        unit: "%/year"
                                    ),
.init(
                                        label: "Direction",
                                        value: result.directionDescription,
                                        unit: "—"
                                    )
                                ],
                                tint: .green
                            )

                            CalculatorInfoCard(tint: .green) {
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
        .navigationTitle("Cost Index Escalation")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    baseCost:
                        try InputValidator.parseNumber(
                            baseCostInput,
                            fieldName:
                                "base cost"
                        ),
                    baseCostIndex:
                        try InputValidator.parseNumber(
                            baseIndexInput,
                            fieldName:
                                "base cost index"
                        ),
                    targetCostIndex:
                        try InputValidator.parseNumber(
                            targetIndexInput,
                            fieldName:
                                "target cost index"
                        ),
                    elapsedYears:
                        try InputValidator.parseNumber(
                            yearsInput,
                            fieldName:
                                "elapsed years"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        baseCostInput = "1000000"
        baseIndexInput = "600"
        targetIndexInput = "750"
        yearsInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        baseCostInput = ""
        baseIndexInput = ""
        targetIndexInput = ""
        yearsInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CostIndexEscalationView()
    }
}
