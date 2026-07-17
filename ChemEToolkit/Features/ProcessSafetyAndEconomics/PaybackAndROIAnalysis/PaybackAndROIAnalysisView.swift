import SwiftUI

struct PaybackAndROIAnalysisView:
    View {

    @State private var investmentInput = "10000000"
    @State private var revenueInput = "5000000"
    @State private var operatingCostInput = "2500000"
    @State private var depreciationInput = "900000"
    @State private var taxRateInput = "0.25"
    @State private var salvageInput = "1000000"
    @State private var lifeInput = "10"

    @State private var result:
        PaybackAndROIAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        PaybackAndROIAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "clock.fill",
                    title: "Payback & ROI Analysis",
                    subtitle: "Estimate after-tax cash flow, simple payback and accounting return",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("This screening calculation converts annual revenue and expenses into after-tax cash flow and accounting return.")
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
                            title: "Initial Investment",
                            symbol: "I₀",
                            unit: "currency",
                            placeholder: "10000000",
                            text: $investmentInput
                        )

                        EngineeringInputField(
                            title: "Annual Revenue",
                            symbol: "R",
                            unit: "currency/year",
                            placeholder: "5000000",
                            text: $revenueInput
                        )

                        EngineeringInputField(
                            title: "Annual Cash Operating Cost",
                            symbol: "OPEX",
                            unit: "currency/year",
                            placeholder: "2500000",
                            text: $operatingCostInput
                        )

                        EngineeringInputField(
                            title: "Annual Depreciation",
                            symbol: "D",
                            unit: "currency/year",
                            placeholder: "900000",
                            text: $depreciationInput
                        )

                        EngineeringInputField(
                            title: "Income Tax Rate",
                            symbol: "t",
                            unit: "fraction",
                            placeholder: "0.25",
                            text: $taxRateInput
                        )

                        EngineeringInputField(
                            title: "Salvage Value",
                            symbol: "S",
                            unit: "currency",
                            placeholder: "1000000",
                            text: $salvageInput
                        )

                        EngineeringInputField(
                            title: "Project Life",
                            symbol: "n",
                            unit: "years",
                            placeholder: "10",
                            text: $lifeInput
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
                            systemImage: "clock.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Earnings Before Tax",
                                        value: numberFormatter.format(result.earningsBeforeTax),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Income Tax",
                                        value: numberFormatter.format(result.incomeTax),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Annual Net Income",
                                        value: numberFormatter.format(result.annualNetIncome),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Annual After-Tax Cash Flow",
                                        value: numberFormatter.format(result.annualAfterTaxCashFlow),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Simple Payback",
                                        value: result.simplePaybackYears.map { numberFormatter.format($0) } ?? "Not available",
                                        unit: "years"
                                    ),
.init(
                                        label: "Accounting ROI",
                                        value: numberFormatter.format(100 * result.accountingROIFraction),
                                        unit: "%/year"
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
        .navigationTitle("Payback & ROI Analysis")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialInvestment:
                        try InputValidator.parseNumber(
                            investmentInput,
                            fieldName:
                                "initial investment"
                        ),
                    annualRevenue:
                        try InputValidator.parseNumber(
                            revenueInput,
                            fieldName:
                                "annual revenue"
                        ),
                    annualCashOperatingCost:
                        try InputValidator.parseNumber(
                            operatingCostInput,
                            fieldName:
                                "annual cash operating cost"
                        ),
                    annualDepreciation:
                        try InputValidator.parseNumber(
                            depreciationInput,
                            fieldName:
                                "annual depreciation"
                        ),
                    incomeTaxRateFraction:
                        try InputValidator.parseNumber(
                            taxRateInput,
                            fieldName:
                                "income tax rate"
                        ),
                    salvageValue:
                        try InputValidator.parseNumber(
                            salvageInput,
                            fieldName:
                                "salvage value"
                        ),
                    projectLifeYears:
                        try InputValidator.parseNumber(
                            lifeInput,
                            fieldName:
                                "project life"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        investmentInput = "10000000"
        revenueInput = "5000000"
        operatingCostInput = "2500000"
        depreciationInput = "900000"
        taxRateInput = "0.25"
        salvageInput = "1000000"
        lifeInput = "10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        investmentInput = ""
        revenueInput = ""
        operatingCostInput = ""
        depreciationInput = ""
        taxRateInput = ""
        salvageInput = ""
        lifeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PaybackAndROIAnalysisView()
    }
}
