import SwiftUI

struct IdealGasMixturePropertiesView:
    View {

    @State private var fraction1Input = "0.78"
    @State private var mw1Input = "28.0134"
    @State private var fraction2Input = "0.21"
    @State private var mw2Input = "31.9988"
    @State private var fraction3Input = "0.01"
    @State private var mw3Input = "39.948"

    @State private var result:
        IdealGasMixturePropertiesResult?

    @State private var errorMessage = ""

    private let engine =
        IdealGasMixturePropertiesEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind",
                    title: "Ideal-Gas Mixture Properties",
                    subtitle: "Calculate mixture molecular weight and gas constant",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Mole fractions are normalized automatically before calculating mixture properties.")
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
                            symbol: "y₁",
                            unit: "—",
                            placeholder: "0.78",
                            text: $fraction1Input
                        )

                        EngineeringInputField(
                            title: "Component 1 Molecular Weight",
                            symbol: "MW₁",
                            unit: "kg/kmol",
                            placeholder: "28.0134",
                            text: $mw1Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Fraction",
                            symbol: "y₂",
                            unit: "—",
                            placeholder: "0.21",
                            text: $fraction2Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Molecular Weight",
                            symbol: "MW₂",
                            unit: "kg/kmol",
                            placeholder: "31.9988",
                            text: $mw2Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Fraction",
                            symbol: "y₃",
                            unit: "—",
                            placeholder: "0.01",
                            text: $fraction3Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Molecular Weight",
                            symbol: "MW₃",
                            unit: "kg/kmol",
                            placeholder: "39.948",
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
                            systemImage: "wind",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Mixture Molecular Weight",
                                        value: numberFormatter.format(result.mixtureMolecularWeight),
                                        unit: "kg/kmol"
                                    ),
.init(
                                        label: "Specific Gas Constant",
                                        value: numberFormatter.format(result.mixtureSpecificGasConstant),
                                        unit: "kJ/(kg·K)"
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
        .navigationTitle("Ideal-Gas Mixture Properties")
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
        fraction1Input = "0.78"
        mw1Input = "28.0134"
        fraction2Input = "0.21"
        mw2Input = "31.9988"
        fraction3Input = "0.01"
        mw3Input = "39.948"
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
        IdealGasMixturePropertiesView()
    }
}
