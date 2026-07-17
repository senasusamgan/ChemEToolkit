import SwiftUI

struct SingleStageGasAbsorptionView:
    View {

    @State private var gasFlowInput = "100"
    @State private var liquidFlowInput = "150"
    @State private var gasFractionInput = "0.10"
    @State private var liquidFractionInput = "0"
    @State private var slopeInput = "1.5"

    @State private var result:
        SingleStageGasAbsorptionResult?

    @State private var errorMessage = ""

    private let engine =
        SingleStageGasAbsorptionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind.and.rain",
                    title: "Single-Stage Gas Absorption",
                    subtitle: "Solve one equilibrium contact between gas and solvent",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The model assumes dilute solute, constant phase flow rates and equilibrium y = mx.")
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
                            title: "Gas Molar Flow",
                            symbol: "G",
                            unit: "kmol/h",
                            placeholder: "100",
                            text: $gasFlowInput
                        )

                        EngineeringInputField(
                            title: "Liquid Molar Flow",
                            symbol: "L",
                            unit: "kmol/h",
                            placeholder: "150",
                            text: $liquidFlowInput
                        )

                        EngineeringInputField(
                            title: "Inlet Gas Solute Fraction",
                            symbol: "y_in",
                            unit: "—",
                            placeholder: "0.10",
                            text: $gasFractionInput
                        )

                        EngineeringInputField(
                            title: "Inlet Liquid Solute Fraction",
                            symbol: "x_in",
                            unit: "—",
                            placeholder: "0",
                            text: $liquidFractionInput
                        )

                        EngineeringInputField(
                            title: "Equilibrium Slope",
                            symbol: "m",
                            unit: "—",
                            placeholder: "1.5",
                            text: $slopeInput
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
                            systemImage: "wind.and.rain",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Outlet Gas Solute Fraction",
                                        value: numberFormatter.format(result.outletGasSoluteFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Outlet Liquid Solute Fraction",
                                        value: numberFormatter.format(result.outletLiquidSoluteFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Solute Absorbed",
                                        value: numberFormatter.format(result.soluteAbsorbedMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Gas-Solute Removal",
                                        value: numberFormatter.format(100 * result.soluteRemovalFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Outlet Gas Solute Flow",
                                        value: numberFormatter.format(result.outletGasSoluteMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Outlet Liquid Solute Flow",
                                        value: numberFormatter.format(result.outletLiquidSoluteMolarFlow),
                                        unit: "kmol/h"
                                    )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
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
        .navigationTitle("Single-Stage Gas Absorption")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    gasMolarFlow:
                        try InputValidator.parseNumber(
                            gasFlowInput,
                            fieldName:
                                "gas molar flow"
                        ),
                    liquidMolarFlow:
                        try InputValidator.parseNumber(
                            liquidFlowInput,
                            fieldName:
                                "liquid molar flow"
                        ),
                    inletGasSoluteFraction:
                        try InputValidator.parseNumber(
                            gasFractionInput,
                            fieldName:
                                "inlet gas solute fraction"
                        ),
                    inletLiquidSoluteFraction:
                        try InputValidator.parseNumber(
                            liquidFractionInput,
                            fieldName:
                                "inlet liquid solute fraction"
                        ),
                    equilibriumSlope:
                        try InputValidator.parseNumber(
                            slopeInput,
                            fieldName:
                                "equilibrium slope"
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
        liquidFlowInput = "150"
        gasFractionInput = "0.10"
        liquidFractionInput = "0"
        slopeInput = "1.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        gasFlowInput = ""
        liquidFlowInput = ""
        gasFractionInput = ""
        liquidFractionInput = ""
        slopeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SingleStageGasAbsorptionView()
    }
}
