import SwiftUI

struct MoleFractionCalculatorView:
    View {

    @State private var componentInput = "2"
    @State private var otherInput = "8"

    @State private var result:
        MoleFractionCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        MoleFractionCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.pie.fill",
                    title: "Mole Fraction",
                    subtitle: "Calculate component fraction from mole amounts",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Enter one component amount and the combined amount of every other component.")
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
                            title: "Component Moles",
                            symbol: "n_i",
                            unit: "mol or kmol",
                            placeholder: "2",
                            text: $componentInput
                        )

                        EngineeringInputField(
                            title: "Other Moles",
                            symbol: "n_other",
                            unit: "same unit",
                            placeholder: "8",
                            text: $otherInput
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
                                        label: "Total Moles",
                                        value: numberFormatter.format(result.totalMoles),
                                        unit: "input amount unit"
                                    ),
.init(
                                        label: "Component Mole Fraction",
                                        value: numberFormatter.format(result.componentMoleFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Other Mole Fraction",
                                        value: numberFormatter.format(result.otherMoleFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Component Mole Percent",
                                        value: numberFormatter.format(result.componentMolePercent),
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
        .navigationTitle("Mole Fraction")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    componentMoles:
                        try InputValidator.parseNumber(
                            componentInput,
                            fieldName:
                                "component moles"
                        ),
                    otherMoles:
                        try InputValidator.parseNumber(
                            otherInput,
                            fieldName:
                                "other moles"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        componentInput = "2"
        otherInput = "8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        componentInput = ""
        otherInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MoleFractionCalculatorView()
    }
}
