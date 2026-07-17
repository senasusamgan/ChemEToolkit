import SwiftUI

struct StreamSplitterBalanceView:
    View {

    @State private var feedInput = "200"
    @State private var splitInput = "0.35"
    @State private var fractionInput = "0.25"

    @State private var result:
        StreamSplitterBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        StreamSplitterBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.branch",
                    title: "Stream Splitter Balance",
                    subtitle: "Split one feed without changing composition",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("An ideal splitter changes only flow rates; both products retain the feed composition.")
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
                            title: "Feed Mass Flow",
                            symbol: "F",
                            unit: "kg/h",
                            placeholder: "200",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Product 1 Split Fraction",
                            symbol: "s₁",
                            unit: "—",
                            placeholder: "0.35",
                            text: $splitInput
                        )

                        EngineeringInputField(
                            title: "Feed Component Fraction",
                            symbol: "w_F",
                            unit: "—",
                            placeholder: "0.25",
                            text: $fractionInput
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
                            systemImage: "arrow.triangle.branch",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Product 1 Mass Flow",
                                        value: numberFormatter.format(result.product1MassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Product 2 Mass Flow",
                                        value: numberFormatter.format(result.product2MassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Product 1 Component Flow",
                                        value: numberFormatter.format(result.product1ComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Product 2 Component Flow",
                                        value: numberFormatter.format(result.product2ComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Product 1 Other Component",
                                        value: numberFormatter.format(result.product1OtherComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Product 2 Other Component",
                                        value: numberFormatter.format(result.product2OtherComponentFlow),
                                        unit: "kg/h"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
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
        .navigationTitle("Stream Splitter Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedMassFlow:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "feed mass flow"
                        ),
                    product1SplitFraction:
                        try InputValidator.parseNumber(
                            splitInput,
                            fieldName:
                                "product 1 split fraction"
                        ),
                    feedComponentMassFraction:
                        try InputValidator.parseNumber(
                            fractionInput,
                            fieldName:
                                "feed component fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "200"
        splitInput = "0.35"
        fractionInput = "0.25"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        splitInput = ""
        fractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        StreamSplitterBalanceView()
    }
}
