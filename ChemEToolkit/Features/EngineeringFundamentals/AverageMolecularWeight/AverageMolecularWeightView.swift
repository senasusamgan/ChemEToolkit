import SwiftUI

struct AverageMolecularWeightView:
    View {

    @State private var fraction1Input = "0.7"
    @State private var mw1Input = "28"
    @State private var fraction2Input = "0.2"
    @State private var mw2Input = "32"
    @State private var fraction3Input = "0.1"
    @State private var mw3Input = "44"

    @State private var result:
        AverageMolecularWeightResult?

    @State private var errorMessage = ""

    private let engine =
        AverageMolecularWeightEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "sum",
                    title: "Average Molecular Weight",
                    subtitle: "Calculate a three-component molar average",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Fractions are normalized automatically before calculating the composition-weighted average.")
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
                            symbol: "x₁",
                            unit: "—",
                            placeholder: "0.7",
                            text: $fraction1Input
                        )

                        EngineeringInputField(
                            title: "Component 1 Molecular Weight",
                            symbol: "MW₁",
                            unit: "kg/kmol",
                            placeholder: "28",
                            text: $mw1Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Fraction",
                            symbol: "x₂",
                            unit: "—",
                            placeholder: "0.2",
                            text: $fraction2Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Molecular Weight",
                            symbol: "MW₂",
                            unit: "kg/kmol",
                            placeholder: "32",
                            text: $mw2Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Fraction",
                            symbol: "x₃",
                            unit: "—",
                            placeholder: "0.1",
                            text: $fraction3Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Molecular Weight",
                            symbol: "MW₃",
                            unit: "kg/kmol",
                            placeholder: "44",
                            text: $mw3Input
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
                                        label: "Average Molecular Weight",
                                        value: numberFormatter.format(result.averageMolecularWeight),
                                        unit: "kg/kmol"
                                    ),
.init(
                                        label: "Reciprocal Average",
                                        value: numberFormatter.format(result.reciprocalAverageMolecularWeight),
                                        unit: "kmol/kg"
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
        .navigationTitle("Average Molecular Weight")
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
                    molecularWeight1:
                        try InputValidator.parseNumber(
                            mw1Input,
                            fieldName:
                                "component 1 molecular weight"
                        ),
                    fraction2:
                        try InputValidator.parseNumber(
                            fraction2Input,
                            fieldName:
                                "component 2 fraction"
                        ),
                    molecularWeight2:
                        try InputValidator.parseNumber(
                            mw2Input,
                            fieldName:
                                "component 2 molecular weight"
                        ),
                    fraction3:
                        try InputValidator.parseNumber(
                            fraction3Input,
                            fieldName:
                                "component 3 fraction"
                        ),
                    molecularWeight3:
                        try InputValidator.parseNumber(
                            mw3Input,
                            fieldName:
                                "component 3 molecular weight"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        fraction1Input = "0.7"
        mw1Input = "28"
        fraction2Input = "0.2"
        mw2Input = "32"
        fraction3Input = "0.1"
        mw3Input = "44"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        fraction1Input = ""
        mw1Input = ""
        fraction2Input = ""
        mw2Input = ""
        fraction3Input = ""
        mw3Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AverageMolecularWeightView()
    }
}
