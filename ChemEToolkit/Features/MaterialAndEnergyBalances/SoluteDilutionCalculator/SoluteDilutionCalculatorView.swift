import SwiftUI

struct SoluteDilutionCalculatorView:
    View {

    @State private var massInput = "100"
    @State private var initialFractionInput = "0.30"
    @State private var targetFractionInput = "0.10"

    @State private var result:
        SoluteDilutionCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        SoluteDilutionCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.triangle.fill",
                    title: "Solute Dilution Calculator",
                    subtitle: "Calculate pure-solvent addition for a target concentration",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Solute mass is conserved while pure solvent is added to reach the target mass fraction.")
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
                            title: "Initial Solution Mass",
                            symbol: "m₀",
                            unit: "kg",
                            placeholder: "100",
                            text: $massInput
                        )

                        EngineeringInputField(
                            title: "Initial Solute Fraction",
                            symbol: "w₀",
                            unit: "—",
                            placeholder: "0.30",
                            text: $initialFractionInput
                        )

                        EngineeringInputField(
                            title: "Target Solute Fraction",
                            symbol: "w_t",
                            unit: "—",
                            placeholder: "0.10",
                            text: $targetFractionInput
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
                            systemImage: "drop.triangle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Solute Mass",
                                        value: numberFormatter.format(result.soluteMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Initial Solvent Mass",
                                        value: numberFormatter.format(result.initialSolventMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Final Solution Mass",
                                        value: numberFormatter.format(result.finalSolutionMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Added Solvent Mass",
                                        value: numberFormatter.format(result.addedSolventMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Final Solvent Mass",
                                        value: numberFormatter.format(result.finalSolventMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Dilution Ratio",
                                        value: numberFormatter.format(result.dilutionRatio),
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
        .navigationTitle("Solute Dilution Calculator")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialSolutionMass:
                        try InputValidator.parseNumber(
                            massInput,
                            fieldName:
                                "initial solution mass"
                        ),
                    initialSoluteMassFraction:
                        try InputValidator.parseNumber(
                            initialFractionInput,
                            fieldName:
                                "initial solute fraction"
                        ),
                    targetSoluteMassFraction:
                        try InputValidator.parseNumber(
                            targetFractionInput,
                            fieldName:
                                "target solute fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massInput = "100"
        initialFractionInput = "0.30"
        targetFractionInput = "0.10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        initialFractionInput = ""
        targetFractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SoluteDilutionCalculatorView()
    }
}
