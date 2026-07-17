import SwiftUI

struct LangFactorCapitalEstimateView:
    View {

    @State private var equipmentCostInput = "5000000"
    @State private var langFactorInput = "4.74"
    @State private var landCostInput = "500000"
    @State private var workingCapitalInput = "0.15"
    @State private var startupInput = "0.05"

    @State private var result:
        LangFactorCapitalEstimateResult?

    @State private var errorMessage = ""

    private let engine =
        LangFactorCapitalEstimateEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "building.2.fill",
                    title: "Lang-Factor Capital Estimate",
                    subtitle: "Estimate fixed and total capital from purchased equipment cost",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("A Lang factor converts total purchased equipment cost into a preliminary fixed-capital estimate.")
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
                            title: "Purchased Equipment Cost",
                            symbol: "C_PE",
                            unit: "currency",
                            placeholder: "5000000",
                            text: $equipmentCostInput
                        )

                        EngineeringInputField(
                            title: "Lang Factor",
                            symbol: "F_L",
                            unit: "—",
                            placeholder: "4.74",
                            text: $langFactorInput
                        )

                        EngineeringInputField(
                            title: "Land Cost",
                            symbol: "C_land",
                            unit: "currency",
                            placeholder: "500000",
                            text: $landCostInput
                        )

                        EngineeringInputField(
                            title: "Working Capital Fraction",
                            symbol: "f_WC",
                            unit: "of fixed capital",
                            placeholder: "0.15",
                            text: $workingCapitalInput
                        )

                        EngineeringInputField(
                            title: "Startup Expense Fraction",
                            symbol: "f_start",
                            unit: "of fixed capital",
                            placeholder: "0.05",
                            text: $startupInput
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
                            systemImage: "building.2.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Fixed Capital Investment",
                                        value: numberFormatter.format(result.fixedCapitalInvestment),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Lang-Factor Added Cost",
                                        value: numberFormatter.format(result.langFactorAddedCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Working Capital",
                                        value: numberFormatter.format(result.workingCapital),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Startup Expense",
                                        value: numberFormatter.format(result.startupExpense),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Total Capital Investment",
                                        value: numberFormatter.format(result.totalCapitalInvestment),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Total / Equipment Cost",
                                        value: numberFormatter.format(result.totalInvestmentToEquipmentRatio),
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
        .navigationTitle("Lang-Factor Capital Estimate")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    purchasedEquipmentCost:
                        try InputValidator.parseNumber(
                            equipmentCostInput,
                            fieldName:
                                "purchased equipment cost"
                        ),
                    langFactor:
                        try InputValidator.parseNumber(
                            langFactorInput,
                            fieldName:
                                "Lang factor"
                        ),
                    landCost:
                        try InputValidator.parseNumber(
                            landCostInput,
                            fieldName:
                                "land cost"
                        ),
                    workingCapitalFractionOfFixedCapital:
                        try InputValidator.parseNumber(
                            workingCapitalInput,
                            fieldName:
                                "working capital fraction"
                        ),
                    startupExpenseFractionOfFixedCapital:
                        try InputValidator.parseNumber(
                            startupInput,
                            fieldName:
                                "startup expense fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        equipmentCostInput = "5000000"
        langFactorInput = "4.74"
        landCostInput = "500000"
        workingCapitalInput = "0.15"
        startupInput = "0.05"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        equipmentCostInput = ""
        langFactorInput = ""
        landCostInput = ""
        workingCapitalInput = ""
        startupInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LangFactorCapitalEstimateView()
    }
}
