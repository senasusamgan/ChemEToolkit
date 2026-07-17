import SwiftUI

struct DaltonPartialPressureView:
    View {

    @State private var pressureInput = "500"
    @State private var fraction1Input = "0.70"
    @State private var fraction2Input = "0.20"
    @State private var fraction3Input = "0.10"

    @State private var result:
        DaltonPartialPressureResult?

    @State private var errorMessage = ""

    private let engine =
        DaltonPartialPressureEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.pie.fill",
                    title: "Dalton Partial Pressure",
                    subtitle: "Calculate ideal-gas component partial pressures",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Composition fractions are normalized automatically before applying pᵢ = yᵢP.")
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
                            title: "Total Absolute Pressure",
                            symbol: "P",
                            unit: "kPa abs",
                            placeholder: "500",
                            text: $pressureInput
                        )

                        EngineeringInputField(
                            title: "Component 1 Fraction",
                            symbol: "y₁",
                            unit: "—",
                            placeholder: "0.70",
                            text: $fraction1Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Fraction",
                            symbol: "y₂",
                            unit: "—",
                            placeholder: "0.20",
                            text: $fraction2Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Fraction",
                            symbol: "y₃",
                            unit: "—",
                            placeholder: "0.10",
                            text: $fraction3Input
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
                            systemImage: "chart.pie.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Entered Fraction Sum",
                                        value: numberFormatter.format(result.enteredFractionSum),
                                        unit: "—"
                                    ),
.init(
                                        label: "Component 1 Partial Pressure",
                                        value: numberFormatter.format(result.partialPressure1),
                                        unit: "kPa"
                                    ),
.init(
                                        label: "Component 2 Partial Pressure",
                                        value: numberFormatter.format(result.partialPressure2),
                                        unit: "kPa"
                                    ),
.init(
                                        label: "Component 3 Partial Pressure",
                                        value: numberFormatter.format(result.partialPressure3),
                                        unit: "kPa"
                                    ),
.init(
                                        label: "Partial-Pressure Sum",
                                        value: numberFormatter.format(result.partialPressureSum),
                                        unit: "kPa"
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
        .navigationTitle("Dalton Partial Pressure")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    totalAbsolutePressure:
                        try InputValidator.parseNumber(
                            pressureInput,
                            fieldName:
                                "total absolute pressure"
                        ),
                    amountFraction1:
                        try InputValidator.parseNumber(
                            fraction1Input,
                            fieldName:
                                "component 1 fraction"
                        ),
                    amountFraction2:
                        try InputValidator.parseNumber(
                            fraction2Input,
                            fieldName:
                                "component 2 fraction"
                        ),
                    amountFraction3:
                        try InputValidator.parseNumber(
                            fraction3Input,
                            fieldName:
                                "component 3 fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        pressureInput = "500"
        fraction1Input = "0.70"
        fraction2Input = "0.20"
        fraction3Input = "0.10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        pressureInput = ""
        fraction1Input = ""
        fraction2Input = ""
        fraction3Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DaltonPartialPressureView()
    }
}
