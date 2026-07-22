import SwiftUI

struct ConcentrationScaleConverterView:
    View {

    @State private var valueInput = "2500"
    @State private var scaleInput = "2"

    @State private var result:
        ConcentrationScaleConverterResult?

    @State private var errorMessage = ""

    private let engine =
        ConcentrationScaleConverterEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "percent",
                    title: "Percent–ppm–ppb Converter",
                    subtitle: "Convert dimensionless concentration scales",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Choose the entered scale using code 1, 2 or 3. All scales must use the same composition basis.")
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
                            title: "Entered Value",
                            symbol: "C",
                            unit: "selected input scale",
                            placeholder: "2500",
                            text: $valueInput
                        )

                        EngineeringInputField(
                            title: "Input Scale Code",
                            symbol: "Scale",
                            unit: "1 percent, 2 ppm, 3 ppb",
                            placeholder: "2",
                            text: $scaleInput
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
                                        label: "Input Scale",
                                        value: result.inputScaleName,
                                        unit: "—"
                                    ),
.init(
                                        label: "Dimensionless Fraction",
                                        value: numberFormatter.format(result.dimensionlessFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Percent",
                                        value: numberFormatter.format(result.percent),
                                        unit: "%"
                                    ),
.init(
                                        label: "Parts per Million",
                                        value: numberFormatter.format(result.partsPerMillion),
                                        unit: "ppm"
                                    ),
.init(
                                        label: "Parts per Billion",
                                        value: numberFormatter.format(result.partsPerBillion),
                                        unit: "ppb"
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
        .navigationTitle("Percent–ppm–ppb Converter")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    enteredValue:
                        try InputValidator.parseNumber(
                            valueInput,
                            fieldName:
                                "entered value"
                        ),
                    inputScaleCode:
                        try InputValidator.parseNumber(
                            scaleInput,
                            fieldName:
                                "input scale code"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        valueInput = "2500"
        scaleInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        valueInput = ""
        scaleInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ConcentrationScaleConverterView()
    }
}
