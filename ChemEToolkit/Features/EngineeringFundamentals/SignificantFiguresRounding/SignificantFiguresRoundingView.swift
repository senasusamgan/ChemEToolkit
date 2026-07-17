import SwiftUI

struct SignificantFiguresRoundingView:
    View {

    @State private var valueInput = "12345.678"
    @State private var digitsInput = "4"

    @State private var result:
        SignificantFiguresRoundingResult?

    @State private var errorMessage = ""

    private let engine =
        SignificantFiguresRoundingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "textformat.123",
                    title: "Significant Figures & Rounding",
                    subtitle: "Round an engineering value to selected significant digits",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The module reports both the rounded value and the introduced numerical difference.")
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
                            title: "Value",
                            symbol: "x",
                            unit: "any unit",
                            placeholder: "12345.678",
                            text: $valueInput
                        )

                        EngineeringInputField(
                            title: "Significant Digits",
                            symbol: "n_sig",
                            unit: "1–15",
                            placeholder: "4",
                            text: $digitsInput
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
                            systemImage: "textformat.123",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Rounded Value",
                                        value: numberFormatter.format(result.roundedValue),
                                        unit: "input unit"
                                    ),
.init(
                                        label: "Significant Digits",
                                        value: String(result.significantDigitCount),
                                        unit: "—"
                                    ),
.init(
                                        label: "Decimal Places Applied",
                                        value: String(result.decimalPlacesApplied),
                                        unit: "—"
                                    ),
.init(
                                        label: "Absolute Difference",
                                        value: numberFormatter.format(result.absoluteRoundingDifference),
                                        unit: "input unit"
                                    ),
.init(
                                        label: "Relative Difference",
                                        value: numberFormatter.format(result.relativeRoundingDifferencePercent),
                                        unit: "%"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Significant Figures & Rounding")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    value:
                        try InputValidator.parseNumber(
                            valueInput,
                            fieldName: "value"
                        ),
                    significantDigitCount:
                        try InputValidator.parseNumber(
                            digitsInput,
                            fieldName:
                                "significant digits"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        valueInput = "12345.678"
        digitsInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        valueInput = ""
        digitsInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SignificantFiguresRoundingView()
    }
}
