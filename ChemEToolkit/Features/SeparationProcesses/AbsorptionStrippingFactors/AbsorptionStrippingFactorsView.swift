import SwiftUI

struct AbsorptionStrippingFactorsView:
    View {

    @State private var liquidFlowInput = "150"
    @State private var gasFlowInput = "100"
    @State private var slopeInput = "1.2"

    @State private var result:
        AbsorptionStrippingFactorsResult?

    @State private var errorMessage = ""

    private let engine =
        AbsorptionStrippingFactorsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.and.down.text.horizontal",
                    title: "Absorption & Stripping Factors",
                    subtitle: "Calculate A = L/(mG) and its reciprocal",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The factors are based on dilute-solute, constant-flow and linear-equilibrium assumptions.")
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
                            title: "Liquid Molar Flow",
                            symbol: "L",
                            unit: "kmol/h",
                            placeholder: "150",
                            text: $liquidFlowInput
                        )

                        EngineeringInputField(
                            title: "Gas Molar Flow",
                            symbol: "G",
                            unit: "kmol/h",
                            placeholder: "100",
                            text: $gasFlowInput
                        )

                        EngineeringInputField(
                            title: "Equilibrium Slope",
                            symbol: "m",
                            unit: "—",
                            placeholder: "1.2",
                            text: $slopeInput
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
                            systemImage: "arrow.up.and.down.text.horizontal",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Absorption Factor",
                                        value: numberFormatter.format(result.absorptionFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Stripping Factor",
                                        value: numberFormatter.format(result.strippingFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Liquid/Gas Ratio",
                                        value: numberFormatter.format(result.liquidToGasRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "mG",
                                        value: numberFormatter.format(result.equilibriumWeightedGasFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Assessment",
                                        value: result.operationDescription,
                                        unit: "—"
                                    )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
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
        .navigationTitle("Absorption & Stripping Factors")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    liquidMolarFlow:
                        try InputValidator.parseNumber(
                            liquidFlowInput,
                            fieldName:
                                "liquid molar flow"
                        ),
                    gasMolarFlow:
                        try InputValidator.parseNumber(
                            gasFlowInput,
                            fieldName:
                                "gas molar flow"
                        ),
                    equilibriumSlope:
                        try InputValidator.parseNumber(
                            slopeInput,
                            fieldName:
                                "equilibrium slope"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        liquidFlowInput = "150"
        gasFlowInput = "100"
        slopeInput = "1.2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        liquidFlowInput = ""
        gasFlowInput = ""
        slopeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        AbsorptionStrippingFactorsView()
    }
}
