import SwiftUI

struct MassFractionCalculatorView:
    View {

    @State private var componentInput = "25"
    @State private var otherInput = "75"

    @State private var result:
        MassFractionCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        MassFractionCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.pie",
                    title: "Mass Fraction",
                    subtitle: "Calculate component fraction from mass values",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Both mass inputs must use the same unit.")
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
                            title: "Component Mass",
                            symbol: "m_i",
                            unit: "kg or g",
                            placeholder: "25",
                            text: $componentInput
                        )

                        EngineeringInputField(
                            title: "Other Mass",
                            symbol: "m_other",
                            unit: "same unit",
                            placeholder: "75",
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
                            systemImage: "chart.pie",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Total Mass",
                                        value: numberFormatter.format(result.totalMass),
                                        unit: "input mass unit"
                                    ),
.init(
                                        label: "Component Mass Fraction",
                                        value: numberFormatter.format(result.componentMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Other Mass Fraction",
                                        value: numberFormatter.format(result.otherMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Component Mass Percent",
                                        value: numberFormatter.format(result.componentMassPercent),
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
        .navigationTitle("Mass Fraction")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    componentMass:
                        try InputValidator.parseNumber(
                            componentInput,
                            fieldName:
                                "component mass"
                        ),
                    otherMass:
                        try InputValidator.parseNumber(
                            otherInput,
                            fieldName:
                                "other mass"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        componentInput = "25"
        otherInput = "75"
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
        MassFractionCalculatorView()
    }
}
