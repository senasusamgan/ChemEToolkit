import SwiftUI

struct FenskeMinimumStagesView:
    View {

    @State private var distillateInput = "0.95"
    @State private var bottomsInput = "0.05"
    @State private var alphaInput = "2.5"

    @State private var result:
        FenskeMinimumStagesResult?

    @State private var errorMessage = ""

    private let engine =
        FenskeMinimumStagesEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.stack.3d.up.fill",
                    title: "Fenske Minimum Stages",
                    subtitle: "Estimate minimum theoretical stages at total reflux",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The result is a continuous theoretical-stage estimate; practical designs round upward.")
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
                            title: "Distillate Light Fraction",
                            symbol: "xD",
                            unit: "—",
                            placeholder: "0.95",
                            text: $distillateInput
                        )

                        EngineeringInputField(
                            title: "Bottoms Light Fraction",
                            symbol: "xB",
                            unit: "—",
                            placeholder: "0.05",
                            text: $bottomsInput
                        )

                        EngineeringInputField(
                            title: "Average Relative Volatility",
                            symbol: "αavg",
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
                            systemImage: "square.stack.3d.up.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Minimum Theoretical Stages",
                                        value: numberFormatter.format(result.minimumTheoreticalStages),
                                        unit: "stages"
                                    ),
.init(
                                        label: "Separation Factor",
                                        value: numberFormatter.format(result.separationFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Distillate Light/Heavy Ratio",
                                        value: numberFormatter.format(result.distillateLightHeavyRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Bottoms Light/Heavy Ratio",
                                        value: numberFormatter.format(result.bottomsLightHeavyRatio),
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
        .navigationTitle("Fenske Minimum Stages")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    distillateLightMoleFraction:
                        try InputValidator.parseNumber(
                            distillateInput,
                            fieldName:
                                "distillate light fraction"
                        ),
                    bottomsLightMoleFraction:
                        try InputValidator.parseNumber(
                            bottomsInput,
                            fieldName:
                                "bottoms light fraction"
                        ),
                    averageRelativeVolatility:
                        try InputValidator.parseNumber(
                            alphaInput,
                            fieldName:
                                "average relative volatility"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        distillateInput = "0.95"
        bottomsInput = "0.05"
        alphaInput = "2.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        distillateInput = ""
        bottomsInput = ""
        alphaInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FenskeMinimumStagesView()
    }
}
