import SwiftUI

struct RTDModelComparisonView:
    View {

    @State private var meanTimeInput =
        "10"

    @State private var varianceInput =
        "25"

    @State private var rateConstantInput =
        "0.2"

    @State private var result:
        RTDModelComparisonResult?

    @State private var errorMessage = ""

    private let engine =
        RTDModelComparisonEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.bar.xaxis.ascending",
                    title:
                        "RTD Model Comparison",
                    subtitle:
                        "Compare first-order PFR, tanks-in-series and CSTR conversion",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Moment-Based Model Mapping")
                            .font(.headline)

                        Text(
                            "N = τ²/σ²,  Pe ≈ 2N"
                        )
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                        Text(
                            "The variance range is restricted to the physical tanks-in-series interval σ²/τ² ≤ 1."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
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
                                "Mean Residence Time",
                            symbol: "τ",
                            unit: "time",
                            placeholder: "10",
                            text: $meanTimeInput
                        )

                        EngineeringInputField(
                            title:
                                "Residence-Time Variance",
                            symbol: "σ²",
                            unit: "time²",
                            placeholder: "25",
                            text: $varianceInput
                        )

                        EngineeringInputField(
                            title:
                                "First-Order Rate Constant",
                            symbol: "k",
                            unit: "1/time",
                            placeholder: "0.2",
                            text:
                                $rateConstantInput
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
                                "Compare RTD Models",
                            systemImage:
                                "chart.bar.xaxis.ascending",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Damköhler Number",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .damkohlerNumber
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Equivalent Tanks",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .equivalentTanksInSeries
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Estimated Peclet Number",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .estimatedPecletNumber
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Ideal PFR Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .idealPFRConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Tanks-in-Series Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .tanksInSeriesConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Ideal CSTR Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .idealCSTRConversion
                                                ),
                                            unit: "%"
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
        .navigationTitle("RTD Model Comparison")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    meanResidenceTime:
                        try InputValidator.parseNumber(
                            meanTimeInput,
                            fieldName:
                                "mean residence time"
                        ),
                    residenceTimeVariance:
                        try InputValidator.parseNumber(
                            varianceInput,
                            fieldName:
                                "residence-time variance"
                        ),
                    firstOrderRateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "first-order rate constant"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        meanTimeInput = "10"
        varianceInput = "25"
        rateConstantInput = "0.2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        meanTimeInput = ""
        varianceInput = ""
        rateConstantInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RTDModelComparisonView()
    }
}
