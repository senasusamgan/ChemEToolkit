import SwiftUI

struct CatalystWeightFromRateDataView:
    View {

    @State private var feedRateInput = "2"
    @State private var initialConversionInput = "0"
    @State private var finalConversionInput = "0.8"
    @State private var inverseRateInitialInput = "1"
    @State private var inverseRateMidInput = "2"
    @State private var inverseRateFinalInput = "5"

    @State private var result:
        CatalystWeightFromRateDataResult?

    @State private var errorMessage = ""

    private let engine =
        CatalystWeightFromRateDataEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "scalemass.fill",
                    title:
                        "Catalyst Weight from Rate Data",
                    subtitle:
                        "Integrate mass-specific rate data for PBR catalyst sizing",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Catalyst Levenspiel Area")
                            .font(.headline)

                        Text(
                            "W = F_A0 ∫ dX/(−r′A)"
                        )
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Three inverse-rate values are integrated with Simpson’s rule."
                        )
                        .foregroundStyle(.secondary)
                    }
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
                            title:
                                "Inlet Molar Flow A",
                            symbol: "F_A0",
                            unit: "mol/s",
                            placeholder: "Example: 2",
                            text: $feedRateInput
                        )

                        EngineeringInputField(
                            title: "Initial Conversion",
                            symbol: "X₀",
                            unit: "—",
                            placeholder: "Example: 0",
                            text:
                                $initialConversionInput
                        )

                        EngineeringInputField(
                            title: "Final Conversion",
                            symbol: "X₁",
                            unit: "—",
                            placeholder: "Example: 0.8",
                            text:
                                $finalConversionInput
                        )

                        EngineeringInputField(
                            title:
                                "1/(−r′A) at X₀",
                            symbol: "f₀",
                            unit: "kg·s/mol",
                            placeholder: "Example: 1",
                            text:
                                $inverseRateInitialInput
                        )

                        EngineeringInputField(
                            title:
                                "1/(−r′A) at Midpoint",
                            symbol: "f_m",
                            unit: "kg·s/mol",
                            placeholder: "Example: 2",
                            text:
                                $inverseRateMidInput
                        )

                        EngineeringInputField(
                            title:
                                "1/(−r′A) at X₁",
                            symbol: "f₁",
                            unit: "kg·s/mol",
                            placeholder: "Example: 5",
                            text:
                                $inverseRateFinalInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
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
                            title:
                                "Calculate Catalyst Weight",
                            systemImage:
                                "scalemass.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Required Catalyst Weight",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredCatalystWeight
                                                ),
                                            unit: "kg catalyst"
                                        ),
                                        .init(
                                            label:
                                                "Catalyst Levenspiel Area",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .catalystLevenspielArea
                                                ),
                                            unit: "kg·s/mol"
                                        ),
                                        .init(
                                            label:
                                                "Average Inverse Rate",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .averageInverseRate
                                                ),
                                            unit: "kg·s/mol"
                                        ),
                                        .init(
                                            label:
                                                "Average Mass-Specific Rate",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .averageMassSpecificRate
                                                ),
                                            unit: "mol/(kg·s)"
                                        ),
                                        .init(
                                            label:
                                                "W / F_A0",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .catalystWeightPerFeedMolarRate
                                                ),
                                            unit: "kg·s/mol"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Catalyst Weight")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletMolarFlowRateA:
                        try InputValidator.parseNumber(
                            feedRateInput,
                            fieldName:
                                "inlet molar flow A"
                        ),
                    initialConversion:
                        try InputValidator.parseNumber(
                            initialConversionInput,
                            fieldName:
                                "initial conversion"
                        ),
                    finalConversion:
                        try InputValidator.parseNumber(
                            finalConversionInput,
                            fieldName:
                                "final conversion"
                        ),
                    inverseRateAtInitialConversion:
                        try InputValidator.parseNumber(
                            inverseRateInitialInput,
                            fieldName:
                                "initial inverse rate"
                        ),
                    inverseRateAtMidpointConversion:
                        try InputValidator.parseNumber(
                            inverseRateMidInput,
                            fieldName:
                                "midpoint inverse rate"
                        ),
                    inverseRateAtFinalConversion:
                        try InputValidator.parseNumber(
                            inverseRateFinalInput,
                            fieldName:
                                "final inverse rate"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        feedRateInput = "2"
        initialConversionInput = "0"
        finalConversionInput = "0.8"
        inverseRateInitialInput = "1"
        inverseRateMidInput = "2"
        inverseRateFinalInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedRateInput = ""
        initialConversionInput = ""
        finalConversionInput = ""
        inverseRateInitialInput = ""
        inverseRateMidInput = ""
        inverseRateFinalInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CatalystWeightFromRateDataView()
    }
}
