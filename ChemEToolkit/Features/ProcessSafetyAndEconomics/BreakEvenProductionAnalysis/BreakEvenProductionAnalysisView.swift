import SwiftUI

struct BreakEvenProductionAnalysisView:
    View {

    @State private var fixedCostInput = "3000000"
    @State private var priceInput = "120"
    @State private var variableCostInput = "70"
    @State private var productionInput = "80000"
    @State private var capacityInput = "120000"

    @State private var result:
        BreakEvenProductionAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        BreakEvenProductionAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.line.uptrend.xyaxis",
                    title: "Break-Even Production",
                    subtitle: "Calculate break-even output, sales and margin of safety",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("Break-even production equals annual fixed cost divided by contribution margin per product unit.")
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
                            title: "Annual Fixed Cost",
                            symbol: "F",
                            unit: "currency/year",
                            placeholder: "3000000",
                            text: $fixedCostInput
                        )

                        EngineeringInputField(
                            title: "Selling Price per Unit",
                            symbol: "P",
                            unit: "currency/unit",
                            placeholder: "120",
                            text: $priceInput
                        )

                        EngineeringInputField(
                            title: "Variable Cost per Unit",
                            symbol: "V",
                            unit: "currency/unit",
                            placeholder: "70",
                            text: $variableCostInput
                        )

                        EngineeringInputField(
                            title: "Expected Annual Production",
                            symbol: "Q",
                            unit: "units/year",
                            placeholder: "80000",
                            text: $productionInput
                        )

                        EngineeringInputField(
                            title: "Maximum Annual Capacity",
                            symbol: "Q_max",
                            unit: "units/year",
                            placeholder: "120000",
                            text: $capacityInput
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
                            systemImage: "chart.line.uptrend.xyaxis",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Contribution Margin",
                                        value: numberFormatter.format(result.contributionMarginPerUnit),
                                        unit: "currency/unit"
                                    ),
.init(
                                        label: "Break-Even Production",
                                        value: numberFormatter.format(result.breakEvenProduction),
                                        unit: "units/year"
                                    ),
.init(
                                        label: "Break-Even Sales Revenue",
                                        value: numberFormatter.format(result.breakEvenSalesRevenue),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Break-Even Capacity Use",
                                        value: numberFormatter.format(100 * result.breakEvenCapacityFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Expected Annual Profit",
                                        value: numberFormatter.format(result.expectedAnnualProfit),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Break-Even Within Capacity",
                                        value: result.breakEvenIsWithinCapacity ? "Yes" : "No",
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
        .navigationTitle("Break-Even Production")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    annualFixedCost:
                        try InputValidator.parseNumber(
                            fixedCostInput,
                            fieldName:
                                "annual fixed cost"
                        ),
                    sellingPricePerUnit:
                        try InputValidator.parseNumber(
                            priceInput,
                            fieldName:
                                "selling price per unit"
                        ),
                    variableCostPerUnit:
                        try InputValidator.parseNumber(
                            variableCostInput,
                            fieldName:
                                "variable cost per unit"
                        ),
                    expectedAnnualProduction:
                        try InputValidator.parseNumber(
                            productionInput,
                            fieldName:
                                "expected annual production"
                        ),
                    maximumAnnualCapacity:
                        try InputValidator.parseNumber(
                            capacityInput,
                            fieldName:
                                "maximum annual capacity"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        fixedCostInput = "3000000"
        priceInput = "120"
        variableCostInput = "70"
        productionInput = "80000"
        capacityInput = "120000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        fixedCostInput = ""
        priceInput = ""
        variableCostInput = ""
        productionInput = ""
        capacityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BreakEvenProductionAnalysisView()
    }
}
