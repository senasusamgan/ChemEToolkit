import SwiftUI

struct EvaporatorBalanceView:
    View {

    @State private var feedInput = "1000"
    @State private var feedFractionInput = "0.10"
    @State private var productFractionInput = "0.40"

    @State private var result:
        EvaporatorBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        EvaporatorBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "flame.fill",
                    title: "Evaporator Balance",
                    subtitle: "Concentrate a nonvolatile solute by solvent evaporation",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("The solute remains entirely in the liquid product while solvent leaves as vapor.")
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
                            placeholder: "1000",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Feed Solute Fraction",
                            symbol: "x_F",
                            unit: "—",
                            placeholder: "0.10",
                            text: $feedFractionInput
                        )

                        EngineeringInputField(
                            title: "Product Solute Fraction",
                            symbol: "x_P",
                            unit: "—",
                            placeholder: "0.40",
                            text: $productFractionInput
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
                            systemImage: "flame.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Feed Solute Flow",
                                        value: numberFormatter.format(result.feedSoluteFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Concentrated Product Flow",
                                        value: numberFormatter.format(result.concentratedProductFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Product Solvent Flow",
                                        value: numberFormatter.format(result.productSolventFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Evaporated Solvent Flow",
                                        value: numberFormatter.format(result.evaporatedSolventFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Concentration Factor",
                                        value: numberFormatter.format(result.concentrationFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Solvent Removal Fraction",
                                        value: numberFormatter.format(100 * result.solventRemovalFraction),
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
        .navigationTitle("Evaporator Balance")
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
                    feedSoluteMassFraction:
                        try InputValidator.parseNumber(
                            feedFractionInput,
                            fieldName:
                                "feed solute fraction"
                        ),
                    productSoluteMassFraction:
                        try InputValidator.parseNumber(
                            productFractionInput,
                            fieldName:
                                "product solute fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "1000"
        feedFractionInput = "0.10"
        productFractionInput = "0.40"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        feedFractionInput = ""
        productFractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EvaporatorBalanceView()
    }
}
