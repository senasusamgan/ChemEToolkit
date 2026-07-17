import SwiftUI

struct NetPresentValueAnalysisView:
    View {

    @State private var investmentInput = "10000000"
    @State private var cashFlowInput = "2000000"
    @State private var lifeInput = "10"
    @State private var discountRateInput = "0.1"
    @State private var terminalInput = "1000000"

    @State private var result:
        NetPresentValueAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        NetPresentValueAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "sum",
                    title: "Net Present Value Analysis",
                    subtitle: "Discount uniform annual cash flows and terminal value",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("NPV compares the present value of future project cash flows with the initial investment.")
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
                            placeholder: "2000000",
                            text: $cashFlowInput
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
                            text: $discountRateInput
                        )

                        EngineeringInputField(
                            title: "Terminal Value",
                            symbol: "TV",
                            unit: "currency",
                            placeholder: "1000000",
                            text: $terminalInput
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
                            systemImage: "sum",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "PV of Annual Cash Flows",
                                        value: numberFormatter.format(result.presentValueOfAnnualCashFlows),
                                        unit: "currency"
                                    ),
.init(
                                        label: "PV of Terminal Value",
                                        value: numberFormatter.format(result.presentValueOfTerminalValue),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Net Present Value",
                                        value: numberFormatter.format(result.netPresentValue),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Profitability Index",
                                        value: numberFormatter.format(result.profitabilityIndex),
                                        unit: "—"
                                    ),
.init(
                                        label: "Discounted Payback",
                                        value: result.discountedPaybackYears.map { numberFormatter.format($0) } ?? "Not reached",
                                        unit: "years"
                                    ),
.init(
                                        label: "Assessment",
                                        value: result.valueCreationDescription,
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
        .navigationTitle("Net Present Value Analysis")
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
                    projectLifeYears:
                        try InputValidator.parseNumber(
                            lifeInput,
                            fieldName:
                                "project life"
                        ),
                    discountRateFraction:
                        try InputValidator.parseNumber(
                            discountRateInput,
                            fieldName:
                                "discount rate"
                        ),
                    terminalValue:
                        try InputValidator.parseNumber(
                            terminalInput,
                            fieldName:
                                "terminal value"
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
        cashFlowInput = "2000000"
        lifeInput = "10"
        discountRateInput = "0.1"
        terminalInput = "1000000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        investmentInput = ""
        cashFlowInput = ""
        lifeInput = ""
        discountRateInput = ""
        terminalInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        NetPresentValueAnalysisView()
    }
}
