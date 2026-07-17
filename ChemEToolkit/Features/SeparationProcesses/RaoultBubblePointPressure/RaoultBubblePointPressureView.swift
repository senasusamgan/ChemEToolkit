import SwiftUI

struct RaoultBubblePointPressureView:
    View {

    @State private var fractionInput = "0.40"
    @State private var pressure1Input = "100"
    @State private var pressure2Input = "40"

    @State private var result:
        RaoultBubblePointPressureResult?

    @State private var errorMessage = ""

    private let engine =
        RaoultBubblePointPressureEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "bubble.left.and.bubble.right.fill",
                    title: "Raoult Bubble-Point Pressure",
                    subtitle: "Calculate ideal binary bubble pressure and first vapor",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Both saturation pressures must correspond to the same temperature and pressure unit.")
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
                            title: "Liquid Mole Fraction 1",
                            symbol: "x₁",
                            unit: "—",
                            placeholder: "0.40",
                            text: $fractionInput
                        )

                        EngineeringInputField(
                            title: "Saturation Pressure 1",
                            symbol: "P₁sat",
                            unit: "kPa",
                            placeholder: "100",
                            text: $pressure1Input
                        )

                        EngineeringInputField(
                            title: "Saturation Pressure 2",
                            symbol: "P₂sat",
                            unit: "kPa",
                            placeholder: "40",
                            text: $pressure2Input
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
                            systemImage: "bubble.left.and.bubble.right.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Bubble-Point Pressure",
                                        value: numberFormatter.format(result.bubblePointPressure),
                                        unit: "kPa"
                                    ),
.init(
                                        label: "Vapor Mole Fraction 1",
                                        value: numberFormatter.format(result.vaporMoleFraction1),
                                        unit: "—"
                                    ),
.init(
                                        label: "Vapor Mole Fraction 2",
                                        value: numberFormatter.format(result.vaporMoleFraction2),
                                        unit: "—"
                                    ),
.init(
                                        label: "Partial Pressure 1",
                                        value: numberFormatter.format(result.partialPressure1),
                                        unit: "kPa"
                                    ),
.init(
                                        label: "Partial Pressure 2",
                                        value: numberFormatter.format(result.partialPressure2),
                                        unit: "kPa"
                                    ),
.init(
                                        label: "Relative Volatility",
                                        value: numberFormatter.format(result.relativeVolatility),
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
        .navigationTitle("Raoult Bubble-Point Pressure")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    liquidMoleFraction1:
                        try InputValidator.parseNumber(
                            fractionInput,
                            fieldName:
                                "liquid mole fraction 1"
                        ),
                    saturationPressure1:
                        try InputValidator.parseNumber(
                            pressure1Input,
                            fieldName:
                                "saturation pressure 1"
                        ),
                    saturationPressure2:
                        try InputValidator.parseNumber(
                            pressure2Input,
                            fieldName:
                                "saturation pressure 2"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        fractionInput = "0.40"
        pressure1Input = "100"
        pressure2Input = "40"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        fractionInput = ""
        pressure1Input = ""
        pressure2Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RaoultBubblePointPressureView()
    }
}
