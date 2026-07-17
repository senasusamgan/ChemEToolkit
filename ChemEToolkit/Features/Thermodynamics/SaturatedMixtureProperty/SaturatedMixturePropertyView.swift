import SwiftUI

struct SaturatedMixturePropertyView:
    View {

    @State private var liquidPropertyInput = "419"
    @State private var vaporPropertyInput = "2676"
    @State private var qualityInput = "0.50"

    @State private var result:
        SaturatedMixturePropertyResult?

    @State private var errorMessage = ""

    private let engine =
        SaturatedMixturePropertyEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "slider.horizontal.3",
                    title: "Saturated Mixture Property",
                    subtitle: "Interpolate v, u, h or s from vapor quality",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use saturated-liquid and saturated-vapor values from the same pressure or temperature state.")
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
                            title: "Saturated-Liquid Property",
                            symbol: "y_f",
                            unit: "selected unit",
                            placeholder: "419",
                            text: $liquidPropertyInput
                        )

                        EngineeringInputField(
                            title: "Saturated-Vapor Property",
                            symbol: "y_g",
                            unit: "same unit",
                            placeholder: "2676",
                            text: $vaporPropertyInput
                        )

                        EngineeringInputField(
                            title: "Vapor Quality",
                            symbol: "x",
                            unit: "—",
                            placeholder: "0.50",
                            text: $qualityInput
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
                            systemImage: "slider.horizontal.3",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Mixture Property",
                                        value: numberFormatter.format(result.mixtureProperty),
                                        unit: "selected property unit"
                                    ),
.init(
                                        label: "Property Difference, yfg",
                                        value: numberFormatter.format(result.propertyDifference),
                                        unit: "selected property unit"
                                    ),
.init(
                                        label: "Liquid Contribution",
                                        value: numberFormatter.format(result.liquidContribution),
                                        unit: "selected property unit"
                                    ),
.init(
                                        label: "Vapor Contribution",
                                        value: numberFormatter.format(result.vaporContribution),
                                        unit: "selected property unit"
                                    ),
.init(
                                        label: "Liquid Mass Fraction",
                                        value: numberFormatter.format(100 * result.liquidMassFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Vapor Mass Fraction",
                                        value: numberFormatter.format(100 * result.vaporMassFraction),
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
        .navigationTitle("Saturated Mixture Property")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    saturatedLiquidProperty:
                        try InputValidator.parseNumber(
                            liquidPropertyInput,
                            fieldName:
                                "saturated-liquid property"
                        ),
                    saturatedVaporProperty:
                        try InputValidator.parseNumber(
                            vaporPropertyInput,
                            fieldName:
                                "saturated-vapor property"
                        ),
                    vaporQuality:
                        try InputValidator.parseNumber(
                            qualityInput,
                            fieldName:
                                "vapor quality"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        liquidPropertyInput = "419"
        vaporPropertyInput = "2676"
        qualityInput = "0.50"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        liquidPropertyInput = ""
        vaporPropertyInput = ""
        qualityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SaturatedMixturePropertyView()
    }
}
