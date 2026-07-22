import SwiftUI

struct ReactiveMaterialBalanceView:
    View {

    @State private var feedInput = "100"
    @State private var reactantCoefficientInput = "2"
    @State private var productCoefficientInput = "3"
    @State private var conversionInput = "0.60"

    @State private var result:
        ReactiveMaterialBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        ReactiveMaterialBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "atom",
                    title: "Reactive Material Balance",
                    subtitle: "Solve a single-reaction balance from conversion",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("The model represents aA → bB with no inert species or side reactions.")
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
                            title: "Reactant Feed Flow",
                            symbol: "F_A0",
                            unit: "kmol/h",
                            placeholder: "100",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Reactant Coefficient",
                            symbol: "a",
                            unit: "—",
                            placeholder: "2",
                            text: $reactantCoefficientInput
                        )

                        EngineeringInputField(
                            title: "Product Coefficient",
                            symbol: "b",
                            unit: "—",
                            placeholder: "3",
                            text: $productCoefficientInput
                        )

                        EngineeringInputField(
                            title: "Reactant Conversion",
                            symbol: "X_A",
                            unit: "—",
                            placeholder: "0.60",
                            text: $conversionInput
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
                            systemImage: "atom",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Reactant Consumed",
                                        value: numberFormatter.format(result.reactantConsumedFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Reactant Outlet",
                                        value: numberFormatter.format(result.reactantOutletFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Product Formation",
                                        value: numberFormatter.format(result.productFormationFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Reaction Extent Rate",
                                        value: numberFormatter.format(result.reactionExtentRate),
                                        unit: "kmol reaction/h"
                                    ),
.init(
                                        label: "Total Outlet Molar Flow",
                                        value: numberFormatter.format(result.totalOutletMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Outlet Product Mole Fraction",
                                        value: numberFormatter.format(result.outletProductMoleFraction),
                                        unit: "—"
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
        .navigationTitle("Reactive Material Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    reactantFeedMolarFlow:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "reactant feed flow"
                        ),
                    reactantStoichiometricCoefficient:
                        try InputValidator.parseNumber(
                            reactantCoefficientInput,
                            fieldName:
                                "reactant coefficient"
                        ),
                    productStoichiometricCoefficient:
                        try InputValidator.parseNumber(
                            productCoefficientInput,
                            fieldName:
                                "product coefficient"
                        ),
                    reactantConversionFraction:
                        try InputValidator.parseNumber(
                            conversionInput,
                            fieldName:
                                "reactant conversion"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "100"
        reactantCoefficientInput = "2"
        productCoefficientInput = "3"
        conversionInput = "0.60"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        reactantCoefficientInput = ""
        productCoefficientInput = ""
        conversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReactiveMaterialBalanceView()
    }
}
