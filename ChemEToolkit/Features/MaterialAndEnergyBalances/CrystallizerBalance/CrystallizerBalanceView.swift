import SwiftUI

struct CrystallizerBalanceView:
    View {

    @State private var feedInput = "1000"
    @State private var feedFractionInput = "0.40"
    @State private var liquorFractionInput = "0.20"
    @State private var crystalFractionInput = "0.95"

    @State private var result:
        CrystallizerBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        CrystallizerBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "snowflake",
                    title: "Crystallizer Balance",
                    subtitle: "Calculate crystal and mother-liquor production",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Feed composition is split between crystals and mother liquor at the entered phase compositions.")
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
                            symbol: "z_F",
                            unit: "—",
                            placeholder: "0.40",
                            text: $feedFractionInput
                        )

                        EngineeringInputField(
                            title: "Mother-Liquor Solute Fraction",
                            symbol: "x_L",
                            unit: "—",
                            placeholder: "0.20",
                            text: $liquorFractionInput
                        )

                        EngineeringInputField(
                            title: "Crystal Solute Fraction",
                            symbol: "x_C",
                            unit: "—",
                            placeholder: "0.95",
                            text: $crystalFractionInput
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
                            systemImage: "snowflake",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Crystal Mass Flow",
                                        value: numberFormatter.format(result.crystalMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Mother-Liquor Flow",
                                        value: numberFormatter.format(result.motherLiquorMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Crystal Solute Flow",
                                        value: numberFormatter.format(result.crystalSoluteFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Mother-Liquor Solute Flow",
                                        value: numberFormatter.format(result.motherLiquorSoluteFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Solute Recovery to Crystals",
                                        value: numberFormatter.format(100 * result.soluteRecoveryToCrystals),
                                        unit: "%"
                                    ),
.init(
                                        label: "Crystal Yield from Feed",
                                        value: numberFormatter.format(100 * result.crystalYieldFromFeed),
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
        .navigationTitle("Crystallizer Balance")
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
                    motherLiquorSoluteMassFraction:
                        try InputValidator.parseNumber(
                            liquorFractionInput,
                            fieldName:
                                "mother-liquor solute fraction"
                        ),
                    crystalSoluteMassFraction:
                        try InputValidator.parseNumber(
                            crystalFractionInput,
                            fieldName:
                                "crystal solute fraction"
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
        feedFractionInput = "0.40"
        liquorFractionInput = "0.20"
        crystalFractionInput = "0.95"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        feedFractionInput = ""
        liquorFractionInput = ""
        crystalFractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CrystallizerBalanceView()
    }
}
