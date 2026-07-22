import SwiftUI

struct MassMoleConversionView:
    View {

    @State private var massInput = "18"
    @State private var molecularWeightInput = "18.01528"

    @State private var result:
        MassMoleConversionResult?

    @State private var errorMessage = ""

    private let engine =
        MassMoleConversionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.left.arrow.right",
                    title: "Mass–Mole Conversion",
                    subtitle: "Convert mass into kmol, mol and mmol",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Molecular weight in kg/kmol has the same numerical value as g/mol.")
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
                            title: "Mass",
                            symbol: "m",
                            unit: "kg",
                            placeholder: "18",
                            text: $massInput
                        )

                        EngineeringInputField(
                            title: "Molecular Weight",
                            symbol: "MW",
                            unit: "kg/kmol",
                            placeholder: "18.01528",
                            text: $molecularWeightInput
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
                            systemImage: "arrow.left.arrow.right",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Amount",
                                        value: numberFormatter.format(result.amountKilomoles),
                                        unit: "kmol"
                                    ),
.init(
                                        label: "Amount",
                                        value: numberFormatter.format(result.amountMoles),
                                        unit: "mol"
                                    ),
.init(
                                        label: "Amount",
                                        value: numberFormatter.format(result.amountMillimoles),
                                        unit: "mmol"
                                    ),
.init(
                                        label: "Back-Calculated Mass",
                                        value: numberFormatter.format(result.backCalculatedMassKilograms),
                                        unit: "kg"
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
        .navigationTitle("Mass–Mole Conversion")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    massKilograms:
                        try InputValidator.parseNumber(
                            massInput,
                            fieldName: "mass"
                        ),
                    molecularWeightKilogramsPerKilomole:
                        try InputValidator.parseNumber(
                            molecularWeightInput,
                            fieldName:
                                "molecular weight"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massInput = "18"
        molecularWeightInput = "18.01528"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        molecularWeightInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MassMoleConversionView()
    }
}
