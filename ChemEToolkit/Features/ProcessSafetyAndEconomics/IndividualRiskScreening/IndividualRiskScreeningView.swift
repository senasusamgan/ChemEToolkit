import SwiftUI

struct IndividualRiskScreeningView:
    View {

    @State private var frequencyInput = "0.001"
    @State private var fatalityInput = "0.1"
    @State private var occupancyInput = "0.25"
    @State private var presenceInput = "0.5"

    @State private var result:
        IndividualRiskScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        IndividualRiskScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "person.crop.circle.badge.exclamationmark",
                    title: "Individual Risk Screening",
                    subtitle: "Estimate annual fatality risk from one scenario",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The screening model multiplies scenario frequency by conditional fatality, occupancy and presence terms.")
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
                            title: "Scenario Frequency",
                            symbol: "f_s",
                            unit: "1/year",
                            placeholder: "0.001",
                            text: $frequencyInput
                        )

                        EngineeringInputField(
                            title: "Fatality Probability Given Exposure",
                            symbol: "P_f|e",
                            unit: "—",
                            placeholder: "0.1",
                            text: $fatalityInput
                        )

                        EngineeringInputField(
                            title: "Occupancy Fraction",
                            symbol: "F_occ",
                            unit: "—",
                            placeholder: "0.25",
                            text: $occupancyInput
                        )

                        EngineeringInputField(
                            title: "Presence Probability",
                            symbol: "P_pres",
                            unit: "—",
                            placeholder: "0.5",
                            text: $presenceInput
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
                            systemImage: "person.crop.circle.badge.exclamationmark",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Annual Individual Risk",
                                        value: numberFormatter.format(result.annualIndividualRisk),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Risk per Million",
                                        value: numberFormatter.format(result.annualIndividualRiskPerMillion),
                                        unit: "per million/year"
                                    ),
.init(
                                        label: "Combined Exposure Probability",
                                        value: numberFormatter.format(result.combinedExposureProbability),
                                        unit: "—"
                                    ),
.init(
                                        label: "Return Period",
                                        value: result.returnPeriodYears.isFinite ? numberFormatter.format(result.returnPeriodYears) : "Infinite",
                                        unit: "years"
                                    ),
.init(
                                        label: "Screening Band",
                                        value: result.screeningBand,
                                        unit: "—"
                                    ),
.init(
                                        label: "Assessment",
                                        value: result.assessmentDescription,
                                        unit: "—"
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
        .navigationTitle("Individual Risk Screening")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    scenarioFrequencyPerYear:
                        try InputValidator.parseNumber(
                            frequencyInput,
                            fieldName:
                                "scenario frequency"
                        ),
                    fatalityProbabilityGivenExposure:
                        try InputValidator.parseNumber(
                            fatalityInput,
                            fieldName:
                                "fatality probability given exposure"
                        ),
                    occupancyFraction:
                        try InputValidator.parseNumber(
                            occupancyInput,
                            fieldName:
                                "occupancy fraction"
                        ),
                    presenceProbability:
                        try InputValidator.parseNumber(
                            presenceInput,
                            fieldName:
                                "presence probability"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        frequencyInput = "0.001"
        fatalityInput = "0.1"
        occupancyInput = "0.25"
        presenceInput = "0.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        frequencyInput = ""
        fatalityInput = ""
        occupancyInput = ""
        presenceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IndividualRiskScreeningView()
    }
}
