import SwiftUI

struct EvaporativeCrystallizerBalanceView: View {

    @State private var feedInput = "1000"

    @State private var feedFractionInput = "0.30"

    @State private var evaporationInput = "300"

    @State private var motherFractionInput = "0.20"

    @State private var purityInput = "0.98"

    @State private var result: EvaporativeCrystallizerBalanceResult?
    @State private var errorMessage = ""

    private let engine = EvaporativeCrystallizerBalanceEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "aqi.medium",
                    title: "Evaporative Crystallizer Balance",
                    subtitle: "Solve crystal, mother-liquor and evaporation flows",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The evaporated stream is treated as pure solvent.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                    EngineeringInputField(
                        title: "Feed Mass Flow",
                        symbol: "F",
                        unit: "kg/h",
                        placeholder: "1000",
                        text: $feedInput
                    )

                    EngineeringInputField(
                        title: "Feed Solute Fraction",
                        symbol: "zF",
                        unit: "—",
                        placeholder: "0.30",
                        text: $feedFractionInput
                    )

                    EngineeringInputField(
                        title: "Solvent Evaporation Flow",
                        symbol: "V",
                        unit: "kg/h",
                        placeholder: "300",
                        text: $evaporationInput
                    )

                    EngineeringInputField(
                        title: "Mother-Liquor Solute Fraction",
                        symbol: "xL",
                        unit: "—",
                        placeholder: "0.20",
                        text: $motherFractionInput
                    )

                    EngineeringInputField(
                        title: "Crystal Purity",
                        symbol: "xC",
                        unit: "—",
                        placeholder: "0.98",
                        text: $purityInput
                    )

                        HStack {
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "aqi.medium",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                label: "Crystal Product Flow",
                                value: numberFormatter.format(result.crystalProductFlow),
                                unit: "kg/h"
                            ),
.init(
                                label: "Mother-Liquor Flow",
                                value: numberFormatter.format(result.motherLiquorFlow),
                                unit: "kg/h"
                            ),
.init(
                                label: "Pure Solute in Crystals",
                                value: numberFormatter.format(result.pureSoluteInCrystals),
                                unit: "kg/h"
                            ),
.init(
                                label: "Solute Recovery",
                                value: numberFormatter.format(100 * result.soluteRecoveryFraction),
                                unit: "%"
                            ),
.init(
                                label: "Total Mass Closure",
                                value: numberFormatter.format(result.totalMassClosure),
                                unit: "kg/h"
                            )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(message: errorMessage)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Evaporative Crystallizer Balance")
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
                                fieldName: "feed mass flow"
                            ),
                        feedSoluteMassFraction:
                            try InputValidator.parseNumber(
                                feedFractionInput,
                                fieldName: "feed solute fraction"
                            ),
                        solventEvaporationFlow:
                            try InputValidator.parseNumber(
                                evaporationInput,
                                fieldName: "solvent evaporation flow"
                            ),
                        motherLiquorSoluteMassFraction:
                            try InputValidator.parseNumber(
                                motherFractionInput,
                                fieldName: "mother-liquor solute fraction"
                            ),
                        crystalPurityFraction:
                            try InputValidator.parseNumber(
                                purityInput,
                                fieldName: "crystal purity"
                            )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetInputs() {
        feedInput = ""
        feedFractionInput = ""
        evaporationInput = ""
        motherFractionInput = ""
        purityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { EvaporativeCrystallizerBalanceView() }
}
