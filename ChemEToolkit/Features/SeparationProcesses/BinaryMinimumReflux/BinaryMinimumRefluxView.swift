import SwiftUI

struct BinaryMinimumRefluxView:
    View {

    @State private var feedInput = "0.40"
    @State private var distillateInput = "0.90"
    @State private var alphaInput = "2.5"

    @State private var result:
        BinaryMinimumRefluxResult?

    @State private var errorMessage = ""

    private let engine =
        BinaryMinimumRefluxEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.uturn.down.circle.fill",
                    title: "Binary Minimum Reflux",
                    subtitle: "Estimate minimum reflux for a saturated-liquid feed",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The estimate uses the feed equilibrium point as the limiting pinch.")
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
                            title: "Feed Light Fraction",
                            symbol: "zF",
                            unit: "—",
                            placeholder: "0.40",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Distillate Light Fraction",
                            symbol: "xD",
                            unit: "—",
                            placeholder: "0.90",
                            text: $distillateInput
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
                            systemImage: "arrow.uturn.down.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Equilibrium Vapor at Feed",
                                        value: numberFormatter.format(result.equilibriumVaporAtFeed),
                                        unit: "—"
                                    ),
.init(
                                        label: "Minimum Operating-Line Slope",
                                        value: numberFormatter.format(result.rectifyingLineMinimumSlope),
                                        unit: "—"
                                    ),
.init(
                                        label: "Minimum Reflux Ratio",
                                        value: numberFormatter.format(result.minimumRefluxRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "Feed Equilibrium Enrichment",
                                        value: numberFormatter.format(result.feedEquilibriumEnrichment),
                                        unit: "—"
                                    ),
.init(
                                        label: "Pinch Model",
                                        value: result.pinchDescription,
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
        .navigationTitle("Binary Minimum Reflux")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedLightMoleFraction:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "feed light fraction"
                        ),
                    distillateLightMoleFraction:
                        try InputValidator.parseNumber(
                            distillateInput,
                            fieldName:
                                "distillate light fraction"
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
        feedInput = "0.40"
        distillateInput = "0.90"
        alphaInput = "2.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        distillateInput = ""
        alphaInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BinaryMinimumRefluxView()
    }
}
