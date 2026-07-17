import SwiftUI

struct SocietalRiskFNScreeningView:
    View {

    @State private var frequencyInput = "0.00001"
    @State private var fatalityInput = "10"
    @State private var referenceInput = "0.001"
    @State private var slopeInput = "2"

    @State private var result:
        SocietalRiskFNScreeningResult?

    @State private var errorMessage = ""

    private let engine =
        SocietalRiskFNScreeningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "person.3.sequence.fill",
                    title: "Societal Risk F–N Screening",
                    subtitle: "Compare one cumulative F–N point with a parameterized criterion",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The entered criterion follows F(N) = F₁ / N^α and is intended only for screening against user-selected values.")
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
                            title: "Cumulative Frequency",
                            symbol: "F(N)",
                            unit: "1/year",
                            placeholder: "0.00001",
                            text: $frequencyInput
                        )

                        EngineeringInputField(
                            title: "Fatality Count",
                            symbol: "N",
                            unit: "fatalities",
                            placeholder: "10",
                            text: $fatalityInput
                        )

                        EngineeringInputField(
                            title: "Reference Frequency at N = 1",
                            symbol: "F₁",
                            unit: "1/year",
                            placeholder: "0.001",
                            text: $referenceInput
                        )

                        EngineeringInputField(
                            title: "Criterion Slope Exponent",
                            symbol: "α",
                            unit: "—",
                            placeholder: "2",
                            text: $slopeInput
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
                            systemImage: "person.3.sequence.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Entered Cumulative Frequency",
                                        value: numberFormatter.format(result.enteredCumulativeFrequency),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Criterion Frequency",
                                        value: numberFormatter.format(result.criterionFrequency),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Frequency / Criterion",
                                        value: numberFormatter.format(result.frequencyToCriterionRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "log₁₀ Entered Frequency",
                                        value: numberFormatter.format(result.log10Frequency),
                                        unit: "—"
                                    ),
.init(
                                        label: "Criterion Exceeded",
                                        value: result.criterionExceeded ? "Yes" : "No",
                                        unit: "—"
                                    ),
.init(
                                        label: "Assessment Band",
                                        value: result.assessmentBand,
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
        .navigationTitle("Societal Risk F–N Screening")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    cumulativeFrequencyPerYear:
                        try InputValidator.parseNumber(
                            frequencyInput,
                            fieldName:
                                "cumulative frequency"
                        ),
                    fatalityCount:
                        try InputValidator.parseNumber(
                            fatalityInput,
                            fieldName:
                                "fatality count"
                        ),
                    referenceFrequencyAtOneFatality:
                        try InputValidator.parseNumber(
                            referenceInput,
                            fieldName:
                                "reference frequency at one fatality"
                        ),
                    criterionSlopeExponent:
                        try InputValidator.parseNumber(
                            slopeInput,
                            fieldName:
                                "criterion slope exponent"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        frequencyInput = "0.00001"
        fatalityInput = "10"
        referenceInput = "0.001"
        slopeInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        frequencyInput = ""
        fatalityInput = ""
        referenceInput = ""
        slopeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SocietalRiskFNScreeningView()
    }
}
