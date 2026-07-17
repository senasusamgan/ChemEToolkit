import SwiftUI

struct VaporQualityFromEnthalpyView:
    View {

    @State private var liquidEnthalpyInput = "419"
    @State private var vaporEnthalpyInput = "2676"
    @State private var mixtureEnthalpyInput = "1547.5"

    @State private var result:
        VaporQualityFromEnthalpyResult?

    @State private var errorMessage = ""

    private let engine =
        VaporQualityFromEnthalpyEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "cloud.fill",
                    title: "Vapor Quality from Enthalpy",
                    subtitle: "Calculate saturated-mixture quality from h, hf and hg",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("All enthalpies must use the same unit and correspond to the same saturation state.")
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
                            title: "Saturated-Liquid Enthalpy",
                            symbol: "h_f",
                            unit: "kJ/kg",
                            placeholder: "419",
                            text: $liquidEnthalpyInput
                        )

                        EngineeringInputField(
                            title: "Saturated-Vapor Enthalpy",
                            symbol: "h_g",
                            unit: "kJ/kg",
                            placeholder: "2676",
                            text: $vaporEnthalpyInput
                        )

                        EngineeringInputField(
                            title: "Mixture Enthalpy",
                            symbol: "h",
                            unit: "kJ/kg",
                            placeholder: "1547.5",
                            text: $mixtureEnthalpyInput
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
                            systemImage: "cloud.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Vapor Quality",
                                        value: numberFormatter.format(result.vaporQuality),
                                        unit: "—"
                                    ),
.init(
                                        label: "Vapor Mass Fraction",
                                        value: numberFormatter.format(100 * result.vaporMassFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Liquid Mass Fraction",
                                        value: numberFormatter.format(100 * result.liquidMassFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Latent Enthalpy, hfg",
                                        value: numberFormatter.format(result.latentEnthalpy),
                                        unit: "kJ/kg"
                                    ),
.init(
                                        label: "Region",
                                        value: result.regionDescription,
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
        .navigationTitle("Vapor Quality from Enthalpy")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    saturatedLiquidEnthalpy:
                        try InputValidator.parseNumber(
                            liquidEnthalpyInput,
                            fieldName:
                                "saturated-liquid enthalpy"
                        ),
                    saturatedVaporEnthalpy:
                        try InputValidator.parseNumber(
                            vaporEnthalpyInput,
                            fieldName:
                                "saturated-vapor enthalpy"
                        ),
                    mixtureEnthalpy:
                        try InputValidator.parseNumber(
                            mixtureEnthalpyInput,
                            fieldName:
                                "mixture enthalpy"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        liquidEnthalpyInput = "419"
        vaporEnthalpyInput = "2676"
        mixtureEnthalpyInput = "1547.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        liquidEnthalpyInput = ""
        vaporEnthalpyInput = ""
        mixtureEnthalpyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        VaporQualityFromEnthalpyView()
    }
}
