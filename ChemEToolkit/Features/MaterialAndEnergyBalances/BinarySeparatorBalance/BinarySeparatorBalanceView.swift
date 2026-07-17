import SwiftUI

struct BinarySeparatorBalanceView:
    View {

    @State private var feedFlowInput = "100"
    @State private var feedFractionInput = "0.4"
    @State private var product1FlowInput = "30"
    @State private var product1FractionInput = "0.8"

    @State private var result:
        BinarySeparatorBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        BinarySeparatorBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.pull",
                    title: "Binary Separator Balance",
                    subtitle: "Solve the second product from total and component balances",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Feed and Product 1 conditions determine Product 2 flow, composition and component recovery.")
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
                            placeholder: "100",
                            text: $feedFlowInput
                        )

                        EngineeringInputField(
                            title: "Feed Component Fraction",
                            symbol: "w_F",
                            unit: "—",
                            placeholder: "0.4",
                            text: $feedFractionInput
                        )

                        EngineeringInputField(
                            title: "Product 1 Mass Flow",
                            symbol: "P₁",
                            unit: "kg/h",
                            placeholder: "30",
                            text: $product1FlowInput
                        )

                        EngineeringInputField(
                            title: "Product 1 Component Fraction",
                            symbol: "w₁",
                            unit: "—",
                            placeholder: "0.8",
                            text: $product1FractionInput
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
                            systemImage: "arrow.triangle.pull",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Product 2 Mass Flow",
                                        value: numberFormatter.format(result.product2MassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Feed Component Flow",
                                        value: numberFormatter.format(result.feedComponentFlow),
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
                                        label: "Product 2 Component Fraction",
                                        value: numberFormatter.format(result.product2ComponentMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Recovery to Product 1",
                                        value: numberFormatter.format(100 * result.componentRecoveryToProduct1),
                                        unit: "%"
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
        .navigationTitle("Binary Separator Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedMassFlow:
                        try InputValidator.parseNumber(
                            feedFlowInput,
                            fieldName:
                                "feed mass flow"
                        ),
                    feedComponentMassFraction:
                        try InputValidator.parseNumber(
                            feedFractionInput,
                            fieldName:
                                "feed component fraction"
                        ),
                    product1MassFlow:
                        try InputValidator.parseNumber(
                            product1FlowInput,
                            fieldName:
                                "product 1 mass flow"
                        ),
                    product1ComponentMassFraction:
                        try InputValidator.parseNumber(
                            product1FractionInput,
                            fieldName:
                                "product 1 component fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedFlowInput = "100"
        feedFractionInput = "0.4"
        product1FlowInput = "30"
        product1FractionInput = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedFlowInput = ""
        feedFractionInput = ""
        product1FlowInput = ""
        product1FractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BinarySeparatorBalanceView()
    }
}
