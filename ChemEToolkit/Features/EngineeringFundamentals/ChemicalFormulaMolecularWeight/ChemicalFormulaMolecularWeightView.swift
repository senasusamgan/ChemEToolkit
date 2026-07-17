import SwiftUI

struct ChemicalFormulaMolecularWeightView:
    View {

    @State private var formulaInput =
        "C6H12O6"

    @State private var result:
        ChemicalFormulaMolecularWeightResult?

    @State private var errorMessage = ""

    private let engine =
        ChemicalFormulaMolecularWeightEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "atom",
                    title:
                        "Chemical Formula Molecular Weight",
                    subtitle:
                        "Parse a simple formula and sum atomic weights",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text(
                        "Examples: H2O, CO2, NaCl, C6H12O6. Parentheses and hydrate notation are intentionally excluded from this introductory parser."
                    )
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
                            title: "Chemical Formula",
                            symbol: "Formula",
                            unit: "element symbols",
                            placeholder: "C6H12O6",
                            text: $formulaInput
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
                            systemImage: "atom",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Formula",
                                        value:
                                            result.normalizedFormula,
                                        unit: "—"
                                    ),
                                    .init(
                                        label:
                                            "Molecular Weight",
                                        value:
                                            numberFormatter.format(
                                                result.molecularWeight
                                            ),
                                        unit: "g/mol"
                                    ),
                                    .init(
                                        label:
                                            "Total Atom Count",
                                        value:
                                            String(
                                                result.totalAtomCount
                                            ),
                                        unit: "atoms/formula"
                                    ),
                                    .init(
                                        label:
                                            "Distinct Elements",
                                        value:
                                            String(
                                                result.distinctElementCount
                                            ),
                                        unit: "—"
                                    ),
                                    .init(
                                        label:
                                            "Elemental Breakdown",
                                        value:
                                            result.elementalBreakdown,
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle(
            "Chemical Formula Molecular Weight"
        )
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    formula: formulaInput
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        formulaInput = "C6H12O6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        formulaInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ChemicalFormulaMolecularWeightView()
    }
}
