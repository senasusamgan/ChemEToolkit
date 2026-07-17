import SwiftUI

struct ExpectedMonetaryValueDecisionView:
    View {

    @State private var aCostInput = "500000"
    @State private var aProbabilityInput = "0.7"
    @State private var aSuccessInput = "1500000"
    @State private var aFailureInput = "-200000"
    @State private var bCostInput = "300000"
    @State private var bProbabilityInput = "0.5"
    @State private var bSuccessInput = "1200000"
    @State private var bFailureInput = "100000"

    @State private var result:
        ExpectedMonetaryValueDecisionResult?

    @State private var errorMessage = ""

    private let engine =
        ExpectedMonetaryValueDecisionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.2.circlepath.circle.fill",
                    title: "Expected Monetary Value Decision",
                    subtitle: "Compare two uncertain investment or project options",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("Each option combines success and failure outcomes with a success probability and initial cost.")
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
                            title: "Option A Initial Cost",
                            symbol: "I_A",
                            unit: "currency",
                            placeholder: "500000",
                            text: $aCostInput
                        )

                        EngineeringInputField(
                            title: "Option A Success Probability",
                            symbol: "P_A",
                            unit: "—",
                            placeholder: "0.7",
                            text: $aProbabilityInput
                        )

                        EngineeringInputField(
                            title: "Option A Success Value",
                            symbol: "V_AS",
                            unit: "currency",
                            placeholder: "1500000",
                            text: $aSuccessInput
                        )

                        EngineeringInputField(
                            title: "Option A Failure Value",
                            symbol: "V_AF",
                            unit: "currency",
                            placeholder: "-200000",
                            text: $aFailureInput
                        )

                        EngineeringInputField(
                            title: "Option B Initial Cost",
                            symbol: "I_B",
                            unit: "currency",
                            placeholder: "300000",
                            text: $bCostInput
                        )

                        EngineeringInputField(
                            title: "Option B Success Probability",
                            symbol: "P_B",
                            unit: "—",
                            placeholder: "0.5",
                            text: $bProbabilityInput
                        )

                        EngineeringInputField(
                            title: "Option B Success Value",
                            symbol: "V_BS",
                            unit: "currency",
                            placeholder: "1200000",
                            text: $bSuccessInput
                        )

                        EngineeringInputField(
                            title: "Option B Failure Value",
                            symbol: "V_BF",
                            unit: "currency",
                            placeholder: "100000",
                            text: $bFailureInput
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
                            systemImage: "arrow.triangle.2.circlepath.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Option A Expected Outcome",
                                        value: numberFormatter.format(result.optionAExpectedOutcome),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Option A Net Expected Value",
                                        value: numberFormatter.format(result.optionANetExpectedValue),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Option B Expected Outcome",
                                        value: numberFormatter.format(result.optionBExpectedOutcome),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Option B Net Expected Value",
                                        value: numberFormatter.format(result.optionBNetExpectedValue),
                                        unit: "currency"
                                    ),
.init(
                                        label: "A − B Expected Value",
                                        value: numberFormatter.format(result.expectedValueDifference),
                                        unit: "currency"
                                    ),
.init(
                                        label: "Preferred Option",
                                        value: result.preferredOption,
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Expected Monetary Value Decision")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    optionAInitialCost:
                        try InputValidator.parseNumber(
                            aCostInput,
                            fieldName:
                                "option A initial cost"
                        ),
                    optionASuccessProbability:
                        try InputValidator.parseNumber(
                            aProbabilityInput,
                            fieldName:
                                "option A success probability"
                        ),
                    optionASuccessValue:
                        try InputValidator.parseNumber(
                            aSuccessInput,
                            fieldName:
                                "option A success value"
                        ),
                    optionAFailureValue:
                        try InputValidator.parseNumber(
                            aFailureInput,
                            fieldName:
                                "option A failure value"
                        ),
                    optionBInitialCost:
                        try InputValidator.parseNumber(
                            bCostInput,
                            fieldName:
                                "option B initial cost"
                        ),
                    optionBSuccessProbability:
                        try InputValidator.parseNumber(
                            bProbabilityInput,
                            fieldName:
                                "option B success probability"
                        ),
                    optionBSuccessValue:
                        try InputValidator.parseNumber(
                            bSuccessInput,
                            fieldName:
                                "option B success value"
                        ),
                    optionBFailureValue:
                        try InputValidator.parseNumber(
                            bFailureInput,
                            fieldName:
                                "option B failure value"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        aCostInput = "500000"
        aProbabilityInput = "0.7"
        aSuccessInput = "1500000"
        aFailureInput = "-200000"
        bCostInput = "300000"
        bProbabilityInput = "0.5"
        bSuccessInput = "1200000"
        bFailureInput = "100000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        aCostInput = ""
        aProbabilityInput = ""
        aSuccessInput = ""
        aFailureInput = ""
        bCostInput = ""
        bProbabilityInput = ""
        bSuccessInput = ""
        bFailureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ExpectedMonetaryValueDecisionView()
    }
}
