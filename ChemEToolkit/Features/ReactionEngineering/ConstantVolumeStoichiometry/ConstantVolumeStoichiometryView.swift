import SwiftUI

struct ConstantVolumeStoichiometryView:
    View {

    @State private var initialAInput = "2"
    @State private var initialBInput = "3"
    @State private var initialProductInput = "0"
    @State private var coefficientAInput = "1"
    @State private var coefficientBInput = "2"
    @State private var coefficientProductInput = "1"
    @State private var conversionAInput = "0.5"

    @State private var result:
        ConstantVolumeStoichiometryResult?

    @State private var errorMessage = ""

    private let engine =
        ConstantVolumeStoichiometryEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "tablecells.fill",
                    title:
                        "Constant-Volume Stoichiometry",
                    subtitle:
                        "Build a concentration table from stoichiometry and conversion",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Stoichiometric Table")
                            .font(.headline)

                        Text("aA + bB → pP")
                            .font(
                                .system(
                                    size: 21,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "For constant volume, ξ/V = C_A0 X_A / a."
                        )
                        .foregroundStyle(.secondary)
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
                        Text("Initial Concentrations")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Initial A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 2",
                            text: $initialAInput
                        )

                        EngineeringInputField(
                            title: "Initial B",
                            symbol: "C_B0",
                            unit: "mol/m³",
                            placeholder: "Example: 3",
                            text: $initialBInput
                        )

                        EngineeringInputField(
                            title: "Initial Product",
                            symbol: "C_P0",
                            unit: "mol/m³",
                            placeholder: "Example: 0",
                            text: $initialProductInput
                        )

                        Divider()

                        Text("Reaction")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Coefficient A",
                            symbol: "a",
                            unit: "—",
                            placeholder: "Example: 1",
                            text: $coefficientAInput
                        )

                        EngineeringInputField(
                            title: "Coefficient B",
                            symbol: "b",
                            unit: "—",
                            placeholder: "Example: 2",
                            text: $coefficientBInput
                        )

                        EngineeringInputField(
                            title: "Product Coefficient",
                            symbol: "p",
                            unit: "—",
                            placeholder: "Example: 1",
                            text:
                                $coefficientProductInput
                        )

                        EngineeringInputField(
                            title: "Conversion of A",
                            symbol: "X_A",
                            unit: "—",
                            placeholder: "Example: 0.5",
                            text: $conversionAInput
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
                                "Calculate Concentrations",
                            systemImage:
                                "tablecells.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Reaction Extent per Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .reactionExtentPerVolume
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Final Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalConcentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Final Concentration B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalConcentrationB
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Final Product Concentration",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalConcentrationProduct
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Conversion of B",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionOfB
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Maximum Feasible X_A",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .maximumFeasibleConversionOfA
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
                                        Text(
                                            result
                                                .limitingReactant
                                                .title
                                        )
                                        .font(.headline)

                                        Divider()

                                        Text(result.modelName)

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
        .navigationTitle("Stoichiometric Table")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialConcentrationA:
                        try InputValidator.parseNumber(
                            initialAInput,
                            fieldName:
                                "initial concentration A"
                        ),
                    initialConcentrationB:
                        try InputValidator.parseNumber(
                            initialBInput,
                            fieldName:
                                "initial concentration B"
                        ),
                    initialConcentrationProduct:
                        try InputValidator.parseNumber(
                            initialProductInput,
                            fieldName:
                                "initial product concentration"
                        ),
                    stoichiometricCoefficientA:
                        try InputValidator.parseNumber(
                            coefficientAInput,
                            fieldName:
                                "stoichiometric coefficient A"
                        ),
                    stoichiometricCoefficientB:
                        try InputValidator.parseNumber(
                            coefficientBInput,
                            fieldName:
                                "stoichiometric coefficient B"
                        ),
                    stoichiometricCoefficientProduct:
                        try InputValidator.parseNumber(
                            coefficientProductInput,
                            fieldName:
                                "product coefficient"
                        ),
                    conversionOfA:
                        try InputValidator.parseNumber(
                            conversionAInput,
                            fieldName:
                                "conversion of A"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialAInput = "2"
        initialBInput = "3"
        initialProductInput = "0"
        coefficientAInput = "1"
        coefficientBInput = "2"
        coefficientProductInput = "1"
        conversionAInput = "0.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialAInput = ""
        initialBInput = ""
        initialProductInput = ""
        coefficientAInput = ""
        coefficientBInput = ""
        coefficientProductInput = ""
        conversionAInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ConstantVolumeStoichiometryView()
    }
}
