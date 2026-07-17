import SwiftUI

struct MassFlowMolarFlowConversionView:
    View {

    @State private var massFlowInput = "1800"
    @State private var molecularWeightInput = "18"

    @State private var result:
        MassFlowMolarFlowConversionResult?

    @State private var errorMessage = ""

    private let engine =
        MassFlowMolarFlowConversionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.left.arrow.right.circle.fill",
                    title: "Mass Flow–Molar Flow",
                    subtitle: "Convert mass flow using molecular weight",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Molecular weight in kg/kmol is numerically equivalent to g/mol.")
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
                            title: "Mass Flow Rate",
                            symbol: "ṁ",
                            unit: "kg/h",
                            placeholder: "1800",
                            text: $massFlowInput
                        )

                        EngineeringInputField(
                            title: "Molecular Weight",
                            symbol: "MW",
                            unit: "kg/kmol",
                            placeholder: "18",
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
                            systemImage: "arrow.left.arrow.right.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Molar Flow Rate",
                                        value: numberFormatter.format(result.molarFlowRateKilomolesPerHour),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Molar Flow Rate",
                                        value: numberFormatter.format(result.molarFlowRateMolesPerSecond),
                                        unit: "mol/s"
                                    ),
.init(
                                        label: "Mass Flow Rate",
                                        value: numberFormatter.format(result.massFlowRateKilogramsPerSecond),
                                        unit: "kg/s"
                                    ),
.init(
                                        label: "Back-Calculated Mass Flow",
                                        value: numberFormatter.format(result.backCalculatedMassFlow),
                                        unit: "kg/h"
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
        .navigationTitle("Mass Flow–Molar Flow")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    massFlowRateKilogramsPerHour:
                        try InputValidator.parseNumber(
                            massFlowInput,
                            fieldName:
                                "mass flow rate"
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
        massFlowInput = "1800"
        molecularWeightInput = "18"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massFlowInput = ""
        molecularWeightInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MassFlowMolarFlowConversionView()
    }
}
