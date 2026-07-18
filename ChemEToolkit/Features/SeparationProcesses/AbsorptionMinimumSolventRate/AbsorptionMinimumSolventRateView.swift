import SwiftUI

    struct AbsorptionMinimumSolventRateView: View {
        @State private var gasFlowInput = "100"

    @State private var yinInput = "0.10"

    @State private var youtInput = "0.02"

    @State private var xinInput = "0"

    @State private var slopeInput = "1.5"

    @State private var factorInput = "1.5"

        @State private var result: AbsorptionMinimumSolventRateResult?
        @State private var errorMessage = ""

        private let engine = AbsorptionMinimumSolventRateEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "arrow.down.to.line.compact",
                        title: "Minimum Solvent Rate for Absorption",
                        subtitle: "Estimate minimum and design solvent flow",
                        tint: .purple
                    )

                    CalculatorInfoCard(tint: .purple) {
                        Text("Use a consistent engineering unit system across all entered quantities.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Gas Molar Flow",
                        symbol: "G",
                        unit: "kmol/h",
                        placeholder: "100",
                        text: $gasFlowInput
                    )

                    EngineeringInputField(
                        title: "Inlet Gas Solute Fraction",
                        symbol: "y_in",
                        unit: "—",
                        placeholder: "0.10",
                        text: $yinInput
                    )

                    EngineeringInputField(
                        title: "Outlet Gas Solute Fraction",
                        symbol: "y_out",
                        unit: "—",
                        placeholder: "0.02",
                        text: $youtInput
                    )

                    EngineeringInputField(
                        title: "Entering Solvent Fraction",
                        symbol: "x_in",
                        unit: "—",
                        placeholder: "0",
                        text: $xinInput
                    )

                    EngineeringInputField(
                        title: "Equilibrium Slope",
                        symbol: "m",
                        unit: "—",
                        placeholder: "1.5",
                        text: $slopeInput
                    )

                    EngineeringInputField(
                        title: "Design Factor",
                        symbol: "F_d",
                        unit: "—",
                        placeholder: "1.5",
                        text: $factorInput
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
                                systemImage: "arrow.down.to.line.compact",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Design Solvent Flow",
                                value: numberFormatter.format(result.designSolventFlow),
                                unit: "kmol/h"
                            ),
.init(
                                label: "Minimum Solvent Flow",
                                value: numberFormatter.format(result.minimumSolventFlow),
                                unit: "kmol/h"
                            ),
.init(
                                label: "Pinch Liquid Composition",
                                value: numberFormatter.format(result.pinchLiquidComposition),
                                unit: "—"
                            ),
.init(
                                label: "Solute Absorbed",
                                value: numberFormatter.format(result.soluteAbsorbedFlow),
                                unit: "kmol/h"
                            ),
.init(
                                label: "Design L/G Ratio",
                                value: numberFormatter.format(result.liquidToGasRatio),
                                unit: "—"
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
            .navigationTitle("Minimum Solvent Rate for Absorption")
        }

        private func calculate() {
            result = nil
            errorMessage = ""

            do {
                result = try engine.calculate(
                    .init(
                            gasMolarFlow: try InputValidator.parseNumber(
                            gasFlowInput,
                            fieldName: "gas molar flow"
                        ),
                        inletGasSoluteFraction: try InputValidator.parseNumber(
                            yinInput,
                            fieldName: "inlet gas solute fraction"
                        ),
                        outletGasSoluteFraction: try InputValidator.parseNumber(
                            youtInput,
                            fieldName: "outlet gas solute fraction"
                        ),
                        inletLiquidSoluteFraction: try InputValidator.parseNumber(
                            xinInput,
                            fieldName: "entering solvent fraction"
                        ),
                        equilibriumSlope: try InputValidator.parseNumber(
                            slopeInput,
                            fieldName: "equilibrium slope"
                        ),
                        designFactor: try InputValidator.parseNumber(
                            factorInput,
                            fieldName: "design factor"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            gasFlowInput = ""
        yinInput = ""
        youtInput = ""
        xinInput = ""
        slopeInput = ""
        factorInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { AbsorptionMinimumSolventRateView() }
    }
