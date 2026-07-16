import SwiftUI

struct ReactiveDistillationBasicsView:
    View {

    @State private var aInput = "1"
    @State private var bInput = "0"
    @State private var equilibriumInput = "2"
    @State private var removalInput = "0.5"
    @State private var stagesInput = "4"
    @State private var result:
        ReactiveDistillationBasicsResult?

    @State private var errorMessage = ""

    private let engine =
        ReactiveDistillationBasicsEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.down.right.and.arrow.up.left",
                    title: "Reactive Distillation Basics",
                    subtitle: "Estimate equilibrium-conversion enhancement from stagewise product removal",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Each ideal stage reaches A ⇌ B equilibrium, then removes a specified fraction of product B.")
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
                            title: "Initial Moles A",
                            symbol: "N_A0",
                            unit: "mol",
                            placeholder: "1",
                            text: $aInput
                        )

                        EngineeringInputField(
                            title: "Initial Moles B",
                            symbol: "N_B0",
                            unit: "mol",
                            placeholder: "0",
                            text: $bInput
                        )

                        EngineeringInputField(
                            title: "Equilibrium Constant",
                            symbol: "K",
                            unit: "—",
                            placeholder: "2",
                            text: $equilibriumInput
                        )

                        EngineeringInputField(
                            title: "B Removal per Stage",
                            symbol: "f",
                            unit: "—",
                            placeholder: "0.5",
                            text: $removalInput
                        )

                        EngineeringInputField(
                            title: "Equilibrium Stages",
                            symbol: "N",
                            unit: "whole number",
                            placeholder: "4",
                            text: $stagesInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
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
                            systemImage: "arrow.down.right.and.arrow.up.left",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Final Moles A",
                                        value: formatter.format(result.finalMolesA),
                                        unit: "mol"
                                    ),
.init(
                                        label: "Retained B",
                                        value: formatter.format(result.retainedMolesB),
                                        unit: "mol"
                                    ),
.init(
                                        label: "Removed B",
                                        value: formatter.format(result.removedMolesB),
                                        unit: "mol"
                                    ),
.init(
                                        label: "Overall Conversion",
                                        value: formatter.format(100 * result.conversionOfInitialA),
                                        unit: "%"
                                    ),
.init(
                                        label: "Equilibrium-Only Conversion",
                                        value: formatter.format(100 * result.equilibriumOnlyConversion),
                                        unit: "%"
                                    ),
.init(
                                        label: "Conversion Enhancement",
                                        value: formatter.format(100 * result.conversionEnhancement),
                                        unit: "percentage points"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Reactive Distillation Basics")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialMolesA: try InputValidator.parseNumber(aInput, fieldName: "initial moles A"),
                    initialMolesB: try InputValidator.parseNumber(bInput, fieldName: "initial moles B"),
                    equilibriumConstant: try InputValidator.parseNumber(equilibriumInput, fieldName: "equilibrium constant"),
                    productRemovalFractionPerStage: try InputValidator.parseNumber(removalInput, fieldName: "product removal fraction"),
                    numberOfStages: try InputValidator.parseNumber(stagesInput, fieldName: "number of stages")
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        aInput = "1"
        bInput = "0"
        equilibriumInput = "2"
        removalInput = "0.5"
        stagesInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        aInput = ""
        bInput = ""
        equilibriumInput = ""
        removalInput = ""
        stagesInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReactiveDistillationBasicsView()
    }
}
