import SwiftUI

struct EngineeringPrefixConverterView:
    View {

    @State private var valueInput = "2.5"
    @State private var inputPowerInput = "6"
    @State private var outputPowerInput = "3"

    @State private var result:
        EngineeringPrefixConverterResult?

    @State private var errorMessage = ""

    private let engine =
        EngineeringPrefixConverterEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "function",
                    title: "Engineering Prefix Converter",
                    subtitle: "Convert pico through tera engineering prefixes",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Enter prefix powers as multiples of three: −12, −9, −6, −3, 0, 3, 6, 9 or 12.")
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
                            symbol: "x",
                            unit: "input prefix unit",
                            placeholder: "2.5",
                            text: $valueInput
                        )

                        EngineeringInputField(
                            title: "Input Power of Ten",
                            symbol: "10^a",
                            unit: "−12 to 12",
                            placeholder: "6",
                            text: $inputPowerInput
                        )

                        EngineeringInputField(
                            title: "Output Power of Ten",
                            symbol: "10^b",
                            unit: "−12 to 12",
                            placeholder: "3",
                            text: $outputPowerInput
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
                            systemImage: "function",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Converted Value",
                                        value: numberFormatter.format(result.convertedValue),
                                        unit: "output prefix unit"
                                    ),
.init(
                                        label: "Conversion Factor",
                                        value: numberFormatter.format(result.conversionFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Input Prefix",
                                        value: result.inputPrefixName,
                                        unit: "—"
                                    ),
.init(
                                        label: "Output Prefix",
                                        value: result.outputPrefixName,
                                        unit: "—"
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
        .navigationTitle("Engineering Prefix Converter")
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
                    inputPowerOfTen:
                        try InputValidator.parseNumber(
                            inputPowerInput,
                            fieldName:
                                "input power of ten"
                        ),
                    outputPowerOfTen:
                        try InputValidator.parseNumber(
                            outputPowerInput,
                            fieldName:
                                "output power of ten"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        valueInput = "2.5"
        inputPowerInput = "6"
        outputPowerInput = "3"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        valueInput = ""
        inputPowerInput = ""
        outputPowerInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EngineeringPrefixConverterView()
    }
}
