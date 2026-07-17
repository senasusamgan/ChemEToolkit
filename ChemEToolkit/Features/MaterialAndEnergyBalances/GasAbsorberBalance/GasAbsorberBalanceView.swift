import SwiftUI

struct GasAbsorberBalanceView:
    View {

    @State private var gasFlowInput = "100"
    @State private var inletFractionInput = "0.10"
    @State private var outletFractionInput = "0.02"

    @State private var result:
        GasAbsorberBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        GasAbsorberBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.down.to.line.compact",
                    title: "Gas Absorber Balance",
                    subtitle: "Calculate absorbed solute from gas compositions",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("The inert carrier gas is conserved while the solute concentration decreases through the absorber.")
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
                            title: "Inlet Gas Molar Flow",
                            symbol: "G₁",
                            unit: "kmol/h",
                            placeholder: "100",
                            text: $gasFlowInput
                        )

                        EngineeringInputField(
                            title: "Inlet Solute Mole Fraction",
                            symbol: "y₁",
                            unit: "—",
                            placeholder: "0.10",
                            text: $inletFractionInput
                        )

                        EngineeringInputField(
                            title: "Outlet Solute Mole Fraction",
                            symbol: "y₂",
                            unit: "—",
                            placeholder: "0.02",
                            text: $outletFractionInput
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
                            systemImage: "arrow.down.to.line.compact",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Inert Gas Flow",
                                        value: numberFormatter.format(result.inertGasMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Outlet Gas Flow",
                                        value: numberFormatter.format(result.outletGasMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Inlet Solute Flow",
                                        value: numberFormatter.format(result.inletSoluteMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Outlet Solute Flow",
                                        value: numberFormatter.format(result.outletSoluteMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Absorbed Solute Flow",
                                        value: numberFormatter.format(result.absorbedSoluteMolarFlow),
                                        unit: "kmol/h"
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
        .navigationTitle("Gas Absorber Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletGasMolarFlow:
                        try InputValidator.parseNumber(
                            gasFlowInput,
                            fieldName:
                                "inlet gas molar flow"
                        ),
                    inletSoluteMoleFraction:
                        try InputValidator.parseNumber(
                            inletFractionInput,
                            fieldName:
                                "inlet solute mole fraction"
                        ),
                    outletSoluteMoleFraction:
                        try InputValidator.parseNumber(
                            outletFractionInput,
                            fieldName:
                                "outlet solute mole fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        gasFlowInput = "100"
        inletFractionInput = "0.10"
        outletFractionInput = "0.02"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        gasFlowInput = ""
        inletFractionInput = ""
        outletFractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        GasAbsorberBalanceView()
    }
}
