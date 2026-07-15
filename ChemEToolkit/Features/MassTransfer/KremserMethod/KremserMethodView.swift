import SwiftUI

struct KremserMethodView: View {
    @State private var operation: KremserOperation = .absorption
    @State private var factor = "1.5"
    @State private var inletRatio = "0.2"
    @State private var targetOutlet = "0.02"
    @State private var result: KremserMethodResult?
    @State private var errorMessage = ""

    private let engine = KremserMethodEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.stack.3d.up",
                    title: "Kremser Method",
                    subtitle: "Estimate ideal stages for dilute absorption or stripping",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Ideal-Stage Kremser Relation").font(.headline)
                        Text("r = (F − 1)/(Fᴺ⁺¹ − 1)")
                            .font(.system(size: 21, weight: .semibold))
                        Text("F is the absorption factor A or stripping factor S. The implemented form assumes dilute operation, linear equilibrium and a lean entering carrier phase.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        Text("Operation").font(.headline)

                        Picker("Operation", selection: $operation) {
                            ForEach(KremserOperation.allCases) {
                                Text($0.title).tag($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        .onChange(of: operation) { loadExample() }

                        Divider()
                        Text("Stage Requirement").font(.headline)

                        EngineeringInputField(
                            title: operation.factorName,
                            symbol: operation == .absorption ? "A" : "S",
                            unit: "—",
                            placeholder: "Example: 1.5",
                            text: $factor
                        )

                        EngineeringInputField(
                            title: "Inlet Solute Ratio",
                            symbol: "Rin",
                            unit: "mol/mol",
                            placeholder: "Example: 0.2",
                            text: $inletRatio
                        )

                        EngineeringInputField(
                            title: "Target Outlet Solute Ratio",
                            symbol: "Rout",
                            unit: "mol/mol",
                            placeholder: "Example: 0.02",
                            text: $targetOutlet
                        )

                        MassTransferActionButtons(loadExample: loadExample, clear: resetInputs)

                        PrimaryActionButton(
                            title: "Calculate Required Stages",
                            systemImage: "square.stack.3d.up",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Continuous Ideal Stages", value: formatter.format(result.continuousIdealStageCount), unit: "stages"),
                                    .init(label: "Required Whole Stages", value: String(result.requiredWholeStageCount), unit: "stages"),
                                    .init(label: "Achieved Outlet Ratio", value: formatter.format(result.achievedOutletSoluteRatio), unit: "mol/mol"),
                                    .init(label: "Target Removal", value: formatter.format(100 * result.targetRemovalFraction), unit: "%"),
                                    .init(label: "Achieved Removal", value: formatter.format(100 * result.achievedRemovalFraction), unit: "%")
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Label(result.factorDescription, systemImage: "square.stack.3d.up")
                                        .font(.headline)
                                    Divider()
                                    Text(result.limitingCaseDescription).foregroundStyle(.secondary)
                                    Text(result.modelName).foregroundStyle(.secondary)
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
        .navigationTitle("Kremser Method")
    }

    private func calculate() {
        clearResult()
        do {
            result = try engine.calculate(
                .init(
                    operation: operation,
                    operatingFactor: try InputValidator.parseNumber(factor, fieldName: operation.factorName),
                    inletSoluteRatio: try InputValidator.parseNumber(inletRatio, fieldName: "inlet solute ratio"),
                    targetOutletSoluteRatio: try InputValidator.parseNumber(targetOutlet, fieldName: "target outlet solute ratio")
                )
            )
        } catch {
            errorMessage = MassTransferViewSupport.errorMessage(for: error)
        }
    }

    private func loadExample() {
        factor = "1.5"
        inletRatio = "0.2"
        targetOutlet = "0.02"
        clearResult()
    }

    private func resetInputs() {
        factor = ""
        inletRatio = ""
        targetOutlet = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { KremserMethodView() }
}
