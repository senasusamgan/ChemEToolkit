import SwiftUI

struct CoolingCrystallizerYieldView: View {

    @State private var solventInput = "100"

    @State private var hotInput = "0.50"

    @State private var coldInput = "0.20"

    @State private var purityInput = "0.98"

    @State private var result: CoolingCrystallizerYieldResult?
    @State private var errorMessage = ""

    private let engine = CoolingCrystallizerYieldEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "snowflake",
                    title: "Cooling Crystallizer Yield",
                    subtitle: "Estimate crystal recovery from solubility change",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Enter solubilities as mass solute per mass solvent.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                    EngineeringInputField(
                        title: "Solvent Mass",
                        symbol: "Msolv",
                        unit: "kg",
                        placeholder: "100",
                        text: $solventInput
                    )

                    EngineeringInputField(
                        title: "Hot Solubility",
                        symbol: "Shot",
                        unit: "kg/kg solvent",
                        placeholder: "0.50",
                        text: $hotInput
                    )

                    EngineeringInputField(
                        title: "Cold Solubility",
                        symbol: "Scold",
                        unit: "kg/kg solvent",
                        placeholder: "0.20",
                        text: $coldInput
                    )

                    EngineeringInputField(
                        title: "Crystal Purity",
                        symbol: "xc",
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
                            systemImage: "snowflake",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                label: "Crystal Product",
                                value: numberFormatter.format(result.recoveredCrystalProduct),
                                unit: "kg"
                            ),
.init(
                                label: "Pure Crystal Mass",
                                value: numberFormatter.format(result.pureCrystalMass),
                                unit: "kg"
                            ),
.init(
                                label: "Solute Recovery",
                                value: numberFormatter.format(100 * result.soluteRecoveryFraction),
                                unit: "%"
                            ),
.init(
                                label: "Initial Dissolved Solute",
                                value: numberFormatter.format(result.initialDissolvedSolute),
                                unit: "kg"
                            ),
.init(
                                label: "Final Dissolved Solute",
                                value: numberFormatter.format(result.finalDissolvedSolute),
                                unit: "kg"
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
        .navigationTitle("Cooling Crystallizer Yield")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                        solventMass:
                            try InputValidator.parseNumber(
                                solventInput,
                                fieldName: "solvent mass"
                            ),
                        hotSolubility:
                            try InputValidator.parseNumber(
                                hotInput,
                                fieldName: "hot solubility"
                            ),
                        coldSolubility:
                            try InputValidator.parseNumber(
                                coldInput,
                                fieldName: "cold solubility"
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
        solventInput = ""
        hotInput = ""
        coldInput = ""
        purityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { CoolingCrystallizerYieldView() }
}
