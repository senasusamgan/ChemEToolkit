import SwiftUI

struct RiskReductionCostEffectivenessView:
    View {

    @State private var currentLossInput = "400000"
    @State private var residualLossInput = "100000"
    @State private var investmentInput = "1000000"
    @State private var maintenanceInput = "25000"
    @State private var lifeInput = "10"
    @State private var discountInput = "0.08"

    @State private var result:
        RiskReductionCostEffectivenessResult?

    @State private var errorMessage = ""

    private let engine =
        RiskReductionCostEffectivenessEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "shield.righthalf.filled",
                    title: "Risk Reduction Cost Effectiveness",
                    subtitle: "Compare discounted avoided loss with safety-investment cost",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("The analysis treats annualized loss reduction as an economic benefit while preserving a clear safety-screening limitation.")
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
                            title: "Current Annualized Loss",
                            symbol: "ALE₀",
                            unit: "currency/year",
                            placeholder: "400000",
                            text: $currentLossInput
                        )

                        EngineeringInputField(
                            title: "Residual Annualized Loss",
                            symbol: "ALE₁",
                            unit: "currency/year",
                            placeholder: "100000",
                            text: $residualLossInput
                        )

                        EngineeringInputField(
                            title: "Initial Safety Investment",
                            symbol: "I₀",
                            unit: "currency",
                            placeholder: "1000000",
                            text: $investmentInput
                        )

                        EngineeringInputField(
                            title: "Annual Maintenance Cost",
                            symbol: "M",
                            unit: "currency/year",
                            placeholder: "25000",
                            text: $maintenanceInput
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
                            systemImage: "shield.righthalf.filled",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Annual Loss Reduction",
                                        value: numberFormatter.format(result.annualLossReduction),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "PV of Loss Reduction",
                                        value: numberFormatter.format(result.presentValueOfLossReduction),
                                        unit: "currency"
                                    ),
.init(
                                        label: "PV of Maintenance",
                                        value: numberFormatter.format(result.presentValueOfMaintenanceCost),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Risk-Reduction NPV",
                                        value: numberFormatter.format(result.netPresentValueOfRiskReduction),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Benefit–Cost Ratio",
                                        value: numberFormatter.format(result.benefitCostRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Simple Payback",
                                        value: result.simplePaybackYears.map { numberFormatter.format($0) } ?? "Not reached",
                                        unit: "years"
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Risk Reduction Cost Effectiveness")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    currentAnnualizedLoss:
                        try InputValidator.parseNumber(
                            currentLossInput,
                            fieldName:
                                "current annualized loss"
                        ),
                    residualAnnualizedLoss:
                        try InputValidator.parseNumber(
                            residualLossInput,
                            fieldName:
                                "residual annualized loss"
                        ),
                    initialRiskReductionInvestment:
                        try InputValidator.parseNumber(
                            investmentInput,
                            fieldName:
                                "initial safety investment"
                        ),
                    annualMaintenanceCost:
                        try InputValidator.parseNumber(
                            maintenanceInput,
                            fieldName:
                                "annual maintenance cost"
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
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        currentLossInput = "400000"
        residualLossInput = "100000"
        investmentInput = "1000000"
        maintenanceInput = "25000"
        lifeInput = "10"
        discountInput = "0.08"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        currentLossInput = ""
        residualLossInput = ""
        investmentInput = ""
        maintenanceInput = ""
        lifeInput = ""
        discountInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RiskReductionCostEffectivenessView()
    }
}
