import SwiftUI

struct InternalRateOfReturnAnalysisView:
    View {

    @State private var investmentInput = "10000000"
    @State private var cashFlowInput = "2200000"
    @State private var terminalInput = "1000000"
    @State private var lifeInput = "10"
    @State private var minimumRateInput = "-0.9"
    @State private var maximumRateInput = "1"

    @State private var result:
        InternalRateOfReturnAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        InternalRateOfReturnAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "percent",
                    title: "Internal Rate of Return",
                    subtitle: "Solve the discount rate that makes project NPV equal to zero",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("IRR is found by bracketing and bisecting the discount rate until the project NPV approaches zero.")
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
                            title: "Minimum Search Rate",
                            symbol: "i_min",
                            unit: "fraction/year",
                            placeholder: "-0.9",
                            text: $minimumRateInput
                        )

                        EngineeringInputField(
                            title: "Maximum Search Rate",
                            symbol: "i_max",
                            unit: "fraction/year",
                            placeholder: "1",
                            text: $maximumRateInput
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
                            systemImage: "percent",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Internal Rate of Return",
                                        value: numberFormatter.format(100 * result.internalRateOfReturn),
                                        unit: "%/year"
                                    ),
.init(
                                        label: "NPV at IRR",
                                        value: numberFormatter.format(result.netPresentValueAtIRR),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Iteration Count",
                                        value: String(result.iterationCount),
                                        unit: "iterations"
                                    ),
.init(
                                        label: "Annual CF / Investment",
                                        value: numberFormatter.format(result.annualCashFlowToInvestmentRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Lower Final Bracket",
                                        value: numberFormatter.format(100 * result.lowerBracketRate),
                                        unit: "%/year"
                                    ),
.init(
                                        label: "Assessment",
                                        value: result.resultDescription,
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
        .navigationTitle("Internal Rate of Return")
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
                    minimumSearchRate:
                        try InputValidator.parseNumber(
                            minimumRateInput,
                            fieldName:
                                "minimum search rate"
                        ),
                    maximumSearchRate:
                        try InputValidator.parseNumber(
                            maximumRateInput,
                            fieldName:
                                "maximum search rate"
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
        minimumRateInput = "-0.9"
        maximumRateInput = "1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        investmentInput = ""
        cashFlowInput = ""
        terminalInput = ""
        lifeInput = ""
        minimumRateInput = ""
        maximumRateInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        InternalRateOfReturnAnalysisView()
    }
}
