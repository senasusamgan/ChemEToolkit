import SwiftUI

struct BinaryRelativeVolatilityVLEView:
    View {

    @State private var liquidInput = "0.40"
    @State private var alphaInput = "2.5"

    @State private var result:
        BinaryRelativeVolatilityVLEResult?

    @State private var errorMessage = ""

    private let engine =
        BinaryRelativeVolatilityVLEEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.xyaxis.line",
                    title: "Binary Relative-Volatility VLE",
                    subtitle: "Calculate equilibrium vapor composition from liquid composition",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The entered component is treated as the more volatile component when α exceeds one.")
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
                            title: "Light-Component Liquid Fraction",
                            symbol: "x",
                            unit: "—",
                            placeholder: "0.40",
                            text: $liquidInput
                        )

                        EngineeringInputField(
                            title: "Relative Volatility",
                            symbol: "α",
                            unit: "—",
                            placeholder: "2.5",
                            text: $alphaInput
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
                            systemImage: "chart.xyaxis.line",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Vapor Mole Fraction",
                                        value: numberFormatter.format(result.vaporMoleFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Vapor/Liquid Enrichment",
                                        value: numberFormatter.format(result.vaporLiquidEnrichment),
                                        unit: "—"
                                    ),
.init(
                                        label: "Equilibrium Separation, y − x",
                                        value: numberFormatter.format(result.equilibriumSeparation),
                                        unit: "—"
                                    ),
.init(
                                        label: "Heavy Liquid Fraction",
                                        value: numberFormatter.format(result.heavyComponentLiquidFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Heavy Vapor Fraction",
                                        value: numberFormatter.format(result.heavyComponentVaporFraction),
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
        .navigationTitle("Binary Relative-Volatility VLE")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    liquidMoleFraction:
                        try InputValidator.parseNumber(
                            liquidInput,
                            fieldName:
                                "liquid mole fraction"
                        ),
                    relativeVolatility:
                        try InputValidator.parseNumber(
                            alphaInput,
                            fieldName:
                                "relative volatility"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        liquidInput = "0.40"
        alphaInput = "2.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        liquidInput = ""
        alphaInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BinaryRelativeVolatilityVLEView()
    }
}
