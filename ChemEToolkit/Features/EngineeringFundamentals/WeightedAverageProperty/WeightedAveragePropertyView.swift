import SwiftUI

struct WeightedAveragePropertyView:
    View {

    @State private var fraction1Input = "0.5"
    @State private var property1Input = "10"
    @State private var fraction2Input = "0.3"
    @State private var property2Input = "20"
    @State private var fraction3Input = "0.2"
    @State private var property3Input = "40"

    @State private var result:
        WeightedAveragePropertyResult?

    @State private var errorMessage = ""

    private let engine =
        WeightedAveragePropertyEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "sum",
                    title: "Weighted Average Property",
                    subtitle: "Calculate a normalized three-component average",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Fractions are normalized automatically. Confirm that linear mixing is valid for the chosen property.")
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
                            title: "Component 1 Fraction",
                            symbol: "f₁",
                            unit: "—",
                            placeholder: "0.5",
                            text: $fraction1Input
                        )

                        EngineeringInputField(
                            title: "Component 1 Property",
                            symbol: "P₁",
                            unit: "property unit",
                            placeholder: "10",
                            text: $property1Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Fraction",
                            symbol: "f₂",
                            unit: "—",
                            placeholder: "0.3",
                            text: $fraction2Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Property",
                            symbol: "P₂",
                            unit: "property unit",
                            placeholder: "20",
                            text: $property2Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Fraction",
                            symbol: "f₃",
                            unit: "—",
                            placeholder: "0.2",
                            text: $fraction3Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Property",
                            symbol: "P₃",
                            unit: "property unit",
                            placeholder: "40",
                            text: $property3Input
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
                            systemImage: "sum",
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
                                        label: "Weighted Average",
                                        value: numberFormatter.format(result.weightedAverageProperty),
                                        unit: "property unit"
                                    ),
.init(
                                        label: "Normalized Fraction 1",
                                        value: numberFormatter.format(result.normalizedFraction1),
                                        unit: "—"
                                    ),
.init(
                                        label: "Normalized Fraction 2",
                                        value: numberFormatter.format(result.normalizedFraction2),
                                        unit: "—"
                                    ),
.init(
                                        label: "Normalized Fraction 3",
                                        value: numberFormatter.format(result.normalizedFraction3),
                                        unit: "—"
                                    ),
.init(
                                        label: "Component Property Range",
                                        value: "\(numberFormatter.format(result.minimumComponentProperty)) – \(numberFormatter.format(result.maximumComponentProperty))",
                                        unit: "property unit"
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
        .navigationTitle("Weighted Average Property")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    fraction1:
                        try InputValidator.parseNumber(
                            fraction1Input,
                            fieldName:
                                "component 1 fraction"
                        ),
                    property1:
                        try InputValidator.parseNumber(
                            property1Input,
                            fieldName:
                                "component 1 property"
                        ),
                    fraction2:
                        try InputValidator.parseNumber(
                            fraction2Input,
                            fieldName:
                                "component 2 fraction"
                        ),
                    property2:
                        try InputValidator.parseNumber(
                            property2Input,
                            fieldName:
                                "component 2 property"
                        ),
                    fraction3:
                        try InputValidator.parseNumber(
                            fraction3Input,
                            fieldName:
                                "component 3 fraction"
                        ),
                    property3:
                        try InputValidator.parseNumber(
                            property3Input,
                            fieldName:
                                "component 3 property"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        fraction1Input = "0.5"
        property1Input = "10"
        fraction2Input = "0.3"
        property2Input = "20"
        fraction3Input = "0.2"
        property3Input = "40"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        fraction1Input = ""
        property1Input = ""
        fraction2Input = ""
        property2Input = ""
        fraction3Input = ""
        property3Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        WeightedAveragePropertyView()
    }
}
