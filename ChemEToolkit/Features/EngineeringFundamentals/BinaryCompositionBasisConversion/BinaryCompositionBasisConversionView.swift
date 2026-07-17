import SwiftUI

struct BinaryCompositionBasisConversionView:
    View {

    @State private var massFractionInput = "0.5"
    @State private var mw1Input = "18"
    @State private var mw2Input = "46"

    @State private var result:
        BinaryCompositionBasisConversionResult?

    @State private var errorMessage = ""

    private let engine =
        BinaryCompositionBasisConversionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.swap",
                    title: "Binary Mass–Mole Fraction",
                    subtitle: "Convert a binary mass composition to mole composition",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The second component mass fraction is calculated as one minus the first component mass fraction.")
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
                            title: "Component 1 Mass Fraction",
                            symbol: "w₁",
                            unit: "—",
                            placeholder: "0.5",
                            text: $massFractionInput
                        )

                        EngineeringInputField(
                            title: "Component 1 Molecular Weight",
                            symbol: "MW₁",
                            unit: "kg/kmol",
                            placeholder: "18",
                            text: $mw1Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Molecular Weight",
                            symbol: "MW₂",
                            unit: "kg/kmol",
                            placeholder: "46",
                            text: $mw2Input
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
                            systemImage: "arrow.triangle.swap",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Component 1 Mole Fraction",
                                        value: numberFormatter.format(result.component1MoleFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Component 2 Mole Fraction",
                                        value: numberFormatter.format(result.component2MoleFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Component 2 Mass Fraction",
                                        value: numberFormatter.format(result.component2MassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Mixture Molecular Weight",
                                        value: numberFormatter.format(result.mixtureMolecularWeight),
                                        unit: "kg/kmol"
                                    ),
.init(
                                        label: "Recovered Component 1 Mass Fraction",
                                        value: numberFormatter.format(result.recoveredMassFraction1),
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
        .navigationTitle("Binary Mass–Mole Fraction")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    component1MassFraction:
                        try InputValidator.parseNumber(
                            massFractionInput,
                            fieldName:
                                "component 1 mass fraction"
                        ),
                    component1MolecularWeight:
                        try InputValidator.parseNumber(
                            mw1Input,
                            fieldName:
                                "component 1 molecular weight"
                        ),
                    component2MolecularWeight:
                        try InputValidator.parseNumber(
                            mw2Input,
                            fieldName:
                                "component 2 molecular weight"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massFractionInput = "0.5"
        mw1Input = "18"
        mw2Input = "46"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massFractionInput = ""
        mw1Input = ""
        mw2Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BinaryCompositionBasisConversionView()
    }
}
