import SwiftUI

struct EquivalentAnnualWorthView:
    View {

    @State private var investmentInput = "10000000"
    @State private var cashFlowInput = "2200000"
    @State private var terminalInput = "1000000"
    @State private var lifeInput = "10"
    @State private var discountInput = "0.1"

    @State private var result:
        EquivalentAnnualWorthResult?

    @State private var errorMessage = ""

    private let engine =
        EquivalentAnnualWorthEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "calendar.badge.clock",
                    title: "Equivalent Annual Worth",
                    subtitle: "Convert project present value into a uniform annual economic measure",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("Annual worth is useful when comparing alternatives with different initial investments or project lives.")
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
                            title: "Annual Net Cash Flow",
                            symbol: "CF",
                            unit: "currency/year",
                            placeholder: "2200000",
                            text: $cashFlowInput
                        )

                        EngineeringInputField(
                            title: "Terminal Value",
                            symbol: "TV",
                            unit: "currency",
                            placeholder: "1000000",
                            text: $terminalInput
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
                            systemImage: "calendar.badge.clock",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Capital Recovery Factor",
                                        value: numberFormatter.format(result.capitalRecoveryFactor),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Sinking Fund Factor",
                                        value: numberFormatter.format(result.sinkingFundFactor),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Annualized Investment",
                                        value: numberFormatter.format(result.annualizedInitialInvestment),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Annualized Terminal Value",
                                        value: numberFormatter.format(result.annualizedTerminalValue),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Equivalent Annual Worth",
                                        value: numberFormatter.format(result.equivalentAnnualWorth),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Present Worth",
                                        value: numberFormatter.format(result.presentWorth),
                                        unit: "currency"
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
        .navigationTitle("Equivalent Annual Worth")
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
                    annualNetCashFlow:
                        try InputValidator.parseNumber(
                            cashFlowInput,
                            fieldName:
                                "annual net cash flow"
                        ),
                    terminalValue:
                        try InputValidator.parseNumber(
                            terminalInput,
                            fieldName:
                                "terminal value"
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
        investmentInput = "10000000"
        cashFlowInput = "2200000"
        terminalInput = "1000000"
        lifeInput = "10"
        discountInput = "0.1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        investmentInput = ""
        cashFlowInput = ""
        terminalInput = ""
        lifeInput = ""
        discountInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EquivalentAnnualWorthView()
    }
}
