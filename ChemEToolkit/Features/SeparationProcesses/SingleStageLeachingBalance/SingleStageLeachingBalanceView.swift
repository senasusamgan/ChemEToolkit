import SwiftUI

struct SingleStageLeachingBalanceView: View {

    @State private var solidInput = "100"

    @State private var loadingInput = "0.20"

    @State private var solventInput = "100"

    @State private var coefficientInput = "2"

    @State private var retentionInput = "0.30"

    @State private var result: SingleStageLeachingBalanceResult?
    @State private var errorMessage = ""

    private let engine = SingleStageLeachingBalanceEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "cube.transparent.fill",
                    title: "Single-Stage Leaching Balance",
                    subtitle: "Estimate solute extraction from an insoluble solid",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Uses a lumped equilibrium distribution coefficient.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                    EngineeringInputField(
                        title: "Dry-Solid Mass",
                        symbol: "Ms",
                        unit: "kg",
                        placeholder: "100",
                        text: $solidInput
                    )

                    EngineeringInputField(
                        title: "Initial Solute on Solid",
                        symbol: "X0",
                        unit: "kg/kg dry solid",
                        placeholder: "0.20",
                        text: $loadingInput
                    )

                    EngineeringInputField(
                        title: "Solvent Mass",
                        symbol: "S",
                        unit: "kg",
                        placeholder: "100",
                        text: $solventInput
                    )

                    EngineeringInputField(
                        title: "Leaching Distribution Coefficient",
                        symbol: "K",
                        unit: "—",
                        placeholder: "2",
                        text: $coefficientInput
                    )

                    EngineeringInputField(
                        title: "Solution Retention",
                        symbol: "R",
                        unit: "kg/kg dry solid",
                        placeholder: "0.30",
                        text: $retentionInput
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
                            systemImage: "cube.transparent.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                label: "Extracted Solute",
                                value: numberFormatter.format(result.extractedSoluteMass),
                                unit: "kg"
                            ),
.init(
                                label: "Retained Solute",
                                value: numberFormatter.format(result.retainedSoluteMass),
                                unit: "kg"
                            ),
.init(
                                label: "Extraction",
                                value: numberFormatter.format(100 * result.extractionFraction),
                                unit: "%"
                            ),
.init(
                                label: "Free Extract Solution",
                                value: numberFormatter.format(result.freeExtractSolutionMass),
                                unit: "kg"
                            ),
.init(
                                label: "Retained Solution",
                                value: numberFormatter.format(result.retainedSolutionMass),
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
        .navigationTitle("Single-Stage Leaching Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                        drySolidMass:
                            try InputValidator.parseNumber(
                                solidInput,
                                fieldName: "dry-solid mass"
                            ),
                        initialSoluteOnSolid:
                            try InputValidator.parseNumber(
                                loadingInput,
                                fieldName: "initial solute on solid"
                            ),
                        solventMass:
                            try InputValidator.parseNumber(
                                solventInput,
                                fieldName: "solvent mass"
                            ),
                        leachingDistributionCoefficient:
                            try InputValidator.parseNumber(
                                coefficientInput,
                                fieldName: "leaching distribution coefficient"
                            ),
                        solventRetentionPerDrySolid:
                            try InputValidator.parseNumber(
                                retentionInput,
                                fieldName: "solution retention"
                            )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetInputs() {
        solidInput = ""
        loadingInput = ""
        solventInput = ""
        coefficientInput = ""
        retentionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { SingleStageLeachingBalanceView() }
}
