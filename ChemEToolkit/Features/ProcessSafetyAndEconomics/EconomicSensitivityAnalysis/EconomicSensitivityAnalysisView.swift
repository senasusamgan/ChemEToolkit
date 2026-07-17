import SwiftUI

struct EconomicSensitivityAnalysisView:
    View {

    @State private var revenueInput = "5000000"
    @State private var operatingCostInput = "3000000"
    @State private var capitalInput = "10000000"
    @State private var revenueChangeInput = "-0.1"
    @State private var operatingChangeInput = "0.1"
    @State private var capitalChangeInput = "0.05"
    @State private var lifeInput = "10"
    @State private var discountInput = "0.1"

    @State private var result:
        EconomicSensitivityAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        EconomicSensitivityAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.left.arrow.right",
                    title: "Economic Sensitivity Analysis",
                    subtitle: "Compare base and scenario economics after revenue, OPEX and CAPEX changes",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("The module applies simultaneous percentage changes and identifies the largest estimated NPV driver.")
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
                            title: "Base Annual Revenue",
                            symbol: "R₀",
                            unit: "currency/year",
                            placeholder: "5000000",
                            text: $revenueInput
                        )

                        EngineeringInputField(
                            title: "Base Annual Operating Cost",
                            symbol: "OPEX₀",
                            unit: "currency/year",
                            placeholder: "3000000",
                            text: $operatingCostInput
                        )

                        EngineeringInputField(
                            title: "Base Capital Investment",
                            symbol: "CAPEX₀",
                            unit: "currency",
                            placeholder: "10000000",
                            text: $capitalInput
                        )

                        EngineeringInputField(
                            title: "Revenue Change",
                            symbol: "ΔR",
                            unit: "fraction",
                            placeholder: "-0.1",
                            text: $revenueChangeInput
                        )

                        EngineeringInputField(
                            title: "Operating-Cost Change",
                            symbol: "ΔOPEX",
                            unit: "fraction",
                            placeholder: "0.1",
                            text: $operatingChangeInput
                        )

                        EngineeringInputField(
                            title: "Capital Change",
                            symbol: "ΔCAPEX",
                            unit: "fraction",
                            placeholder: "0.05",
                            text: $capitalChangeInput
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
                            placeholder: "0.1",
                            text: $discountInput
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
                            systemImage: "arrow.left.arrow.right",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Base NPV",
                                        value: numberFormatter.format(result.baseNetPresentValue),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Scenario NPV",
                                        value: numberFormatter.format(result.scenarioNetPresentValue),
                                        unit: "currency"
                                    ),
.init(
                                        label: "NPV Change",
                                        value: numberFormatter.format(result.netPresentValueChange),
                                        unit: "currency"
                                    ),
.init(
                                        label: "NPV Change",
                                        value: result.netPresentValueChangeFraction.map { numberFormatter.format(100 * $0) } ?? "Undefined",
                                        unit: "%"
                                    ),
.init(
                                        label: "Scenario Payback",
                                        value: result.scenarioSimplePaybackYears.map { numberFormatter.format($0) } ?? "Not reached",
                                        unit: "years"
                                    ),
.init(
                                        label: "Dominant Driver",
                                        value: result.dominantSensitivityDriver,
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
        .navigationTitle("Economic Sensitivity Analysis")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    baseAnnualRevenue:
                        try InputValidator.parseNumber(
                            revenueInput,
                            fieldName:
                                "base annual revenue"
                        ),
                    baseAnnualOperatingCost:
                        try InputValidator.parseNumber(
                            operatingCostInput,
                            fieldName:
                                "base annual operating cost"
                        ),
                    baseCapitalInvestment:
                        try InputValidator.parseNumber(
                            capitalInput,
                            fieldName:
                                "base capital investment"
                        ),
                    revenueChangeFraction:
                        try InputValidator.parseNumber(
                            revenueChangeInput,
                            fieldName:
                                "revenue change"
                        ),
                    operatingCostChangeFraction:
                        try InputValidator.parseNumber(
                            operatingChangeInput,
                            fieldName:
                                "operating-cost change"
                        ),
                    capitalChangeFraction:
                        try InputValidator.parseNumber(
                            capitalChangeInput,
                            fieldName:
                                "capital change"
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
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        revenueInput = "5000000"
        operatingCostInput = "3000000"
        capitalInput = "10000000"
        revenueChangeInput = "-0.1"
        operatingChangeInput = "0.1"
        capitalChangeInput = "0.05"
        lifeInput = "10"
        discountInput = "0.1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        revenueInput = ""
        operatingCostInput = ""
        capitalInput = ""
        revenueChangeInput = ""
        operatingChangeInput = ""
        capitalChangeInput = ""
        lifeInput = ""
        discountInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EconomicSensitivityAnalysisView()
    }
}
