import SwiftUI

struct AnnualizedLossExpectancyView:
    View {

    @State private var frequencyInput = "0.02"
    @State private var assetInput = "5000000"
    @State private var businessInput = "3000000"
    @State private var environmentInput = "1000000"
    @State private var liabilityInput = "2000000"
    @State private var insuranceInput = "0.4"

    @State private var result:
        AnnualizedLossExpectancyResult?

    @State private var errorMessage = ""

    private let engine =
        AnnualizedLossExpectancyEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "exclamationmark.arrow.triangle.2.circlepath",
                    title: "Annualized Loss Expectancy",
                    subtitle: "Convert event frequency and consequence into expected annual loss",
                    tint: .green
                )

                CalculatorInfoCard(tint: .green) {
                    Text("The module combines four consequence categories and optional insurance recovery before annualization.")
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
                            title: "Event Frequency",
                            symbol: "f",
                            unit: "1/year",
                            placeholder: "0.02",
                            text: $frequencyInput
                        )

                        EngineeringInputField(
                            title: "Asset Damage Cost",
                            symbol: "C_asset",
                            unit: "currency/event",
                            placeholder: "5000000",
                            text: $assetInput
                        )

                        EngineeringInputField(
                            title: "Business Interruption Cost",
                            symbol: "C_BI",
                            unit: "currency/event",
                            placeholder: "3000000",
                            text: $businessInput
                        )

                        EngineeringInputField(
                            title: "Environmental Remediation Cost",
                            symbol: "C_env",
                            unit: "currency/event",
                            placeholder: "1000000",
                            text: $environmentInput
                        )

                        EngineeringInputField(
                            title: "Injury and Liability Cost",
                            symbol: "C_liab",
                            unit: "currency/event",
                            placeholder: "2000000",
                            text: $liabilityInput
                        )

                        EngineeringInputField(
                            title: "Insurance Recovery Fraction",
                            symbol: "f_ins",
                            unit: "fraction",
                            placeholder: "0.4",
                            text: $insuranceInput
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
                            systemImage: "exclamationmark.arrow.triangle.2.circlepath",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Gross Single-Event Loss",
                                        value: numberFormatter.format(result.grossSingleEventLoss),
                                        unit: "currency/event"
                                    ),
.init(
                                        label: "Insurance Recovery",
                                        value: numberFormatter.format(result.insuranceRecovery),
                                        unit: "currency/event"
                                    ),
.init(
                                        label: "Retained Single-Event Loss",
                                        value: numberFormatter.format(result.retainedSingleEventLoss),
                                        unit: "currency/event"
                                    ),
.init(
                                        label: "Annualized Gross Loss",
                                        value: numberFormatter.format(result.annualizedGrossLoss),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Annualized Retained Loss",
                                        value: numberFormatter.format(result.annualizedRetainedLoss),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Dominant Loss Category",
                                        value: result.dominantLossCategory,
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
        .navigationTitle("Annualized Loss Expectancy")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    eventFrequencyPerYear:
                        try InputValidator.parseNumber(
                            frequencyInput,
                            fieldName:
                                "event frequency"
                        ),
                    assetDamageCost:
                        try InputValidator.parseNumber(
                            assetInput,
                            fieldName:
                                "asset damage cost"
                        ),
                    businessInterruptionCost:
                        try InputValidator.parseNumber(
                            businessInput,
                            fieldName:
                                "business interruption cost"
                        ),
                    environmentalRemediationCost:
                        try InputValidator.parseNumber(
                            environmentInput,
                            fieldName:
                                "environmental remediation cost"
                        ),
                    injuryAndLiabilityCost:
                        try InputValidator.parseNumber(
                            liabilityInput,
                            fieldName:
                                "injury and liability cost"
                        ),
                    insuranceRecoveryFraction:
                        try InputValidator.parseNumber(
                            insuranceInput,
                            fieldName:
                                "insurance recovery fraction"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        frequencyInput = "0.02"
        assetInput = "5000000"
        businessInput = "3000000"
        environmentInput = "1000000"
        liabilityInput = "2000000"
        insuranceInput = "0.4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        frequencyInput = ""
        assetInput = ""
        businessInput = ""
        environmentInput = ""
        liabilityInput = ""
        insuranceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AnnualizedLossExpectancyView()
    }
}
