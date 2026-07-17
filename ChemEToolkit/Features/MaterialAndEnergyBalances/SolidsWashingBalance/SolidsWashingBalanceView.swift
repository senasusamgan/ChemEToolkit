import SwiftUI

struct SolidsWashingBalanceView:
    View {

    @State private var initialSolutionInput = "100"
    @State private var soluteFractionInput = "0.20"
    @State private var washInput = "100"
    @State private var finalRetainedInput = "100"

    @State private var result:
        SolidsWashingBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        SolidsWashingBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.circle",
                    title: "Solids Washing Balance",
                    subtitle: "Model one ideal mixing-and-drainage washing stage",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Pure wash solvent mixes with retained solution before liquid drains to the final retained holdup.")
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
                            title: "Initial Retained Solution",
                            symbol: "L₀",
                            unit: "kg",
                            placeholder: "100",
                            text: $initialSolutionInput
                        )

                        EngineeringInputField(
                            title: "Initial Solute Fraction",
                            symbol: "w₀",
                            unit: "—",
                            placeholder: "0.20",
                            text: $soluteFractionInput
                        )

                        EngineeringInputField(
                            title: "Wash Solvent Mass",
                            symbol: "W",
                            unit: "kg",
                            placeholder: "100",
                            text: $washInput
                        )

                        EngineeringInputField(
                            title: "Final Retained Solution",
                            symbol: "L_f",
                            unit: "kg",
                            placeholder: "100",
                            text: $finalRetainedInput
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
                            systemImage: "drop.circle",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Initial Solute Mass",
                                        value: numberFormatter.format(result.initialSoluteMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Mixed Liquid Mass",
                                        value: numberFormatter.format(result.totalMixedLiquidMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Mixed Solute Fraction",
                                        value: numberFormatter.format(result.mixedLiquidSoluteMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Final Retained Solute",
                                        value: numberFormatter.format(result.finalRetainedSoluteMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Wash Effluent Mass",
                                        value: numberFormatter.format(result.washEffluentMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Solute Removed",
                                        value: numberFormatter.format(result.soluteRemovedMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Solute Removal",
                                        value: numberFormatter.format(100 * result.soluteRemovalFraction),
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
        .navigationTitle("Solids Washing Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialRetainedSolutionMass:
                        try InputValidator.parseNumber(
                            initialSolutionInput,
                            fieldName:
                                "initial retained solution"
                        ),
                    initialSoluteMassFraction:
                        try InputValidator.parseNumber(
                            soluteFractionInput,
                            fieldName:
                                "initial solute fraction"
                        ),
                    washSolventMass:
                        try InputValidator.parseNumber(
                            washInput,
                            fieldName:
                                "wash solvent mass"
                        ),
                    finalRetainedSolutionMass:
                        try InputValidator.parseNumber(
                            finalRetainedInput,
                            fieldName:
                                "final retained solution"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialSolutionInput = "100"
        soluteFractionInput = "0.20"
        washInput = "100"
        finalRetainedInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialSolutionInput = ""
        soluteFractionInput = ""
        washInput = ""
        finalRetainedInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SolidsWashingBalanceView()
    }
}
