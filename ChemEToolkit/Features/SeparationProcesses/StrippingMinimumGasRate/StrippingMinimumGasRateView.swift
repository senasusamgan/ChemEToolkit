import SwiftUI

    struct StrippingMinimumGasRateView: View {
        @State private var liquidFlowInput = "100"

    @State private var xinInput = "0.10"

    @State private var xoutInput = "0.02"

    @State private var yinInput = "0"

    @State private var slopeInput = "1.5"

    @State private var factorInput = "1.5"

        @State private var result: StrippingMinimumGasRateResult?
        @State private var errorMessage = ""

        private let engine = StrippingMinimumGasRateEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "arrow.up.to.line.compact",
                        title: "Minimum Gas Rate for Stripping",
                        subtitle: "Estimate minimum and design stripping-gas flow",
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
                        title: "Liquid Molar Flow",
                        symbol: "L",
                        unit: "kmol/h",
                        placeholder: "100",
                        text: $liquidFlowInput
                    )

                    EngineeringInputField(
                        title: "Inlet Liquid Solute Fraction",
                        symbol: "x_in",
                        unit: "—",
                        placeholder: "0.10",
                        text: $xinInput
                    )

                    EngineeringInputField(
                        title: "Outlet Liquid Solute Fraction",
                        symbol: "x_out",
                        unit: "—",
                        placeholder: "0.02",
                        text: $xoutInput
                    )

                    EngineeringInputField(
                        title: "Entering Gas Solute Fraction",
                        symbol: "y_in",
                        unit: "—",
                        placeholder: "0",
                        text: $yinInput
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
                                systemImage: "arrow.up.to.line.compact",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Design Gas Flow",
                                value: numberFormatter.format(result.designGasFlow),
                                unit: "kmol/h"
                            ),
.init(
                                label: "Minimum Gas Flow",
                                value: numberFormatter.format(result.minimumGasFlow),
                                unit: "kmol/h"
                            ),
.init(
                                label: "Pinch Gas Composition",
                                value: numberFormatter.format(result.pinchGasComposition),
                                unit: "—"
                            ),
.init(
                                label: "Solute Stripped",
                                value: numberFormatter.format(result.soluteStrippedFlow),
                                unit: "kmol/h"
                            ),
.init(
                                label: "Design G/L Ratio",
                                value: numberFormatter.format(result.gasToLiquidRatio),
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
            .navigationTitle("Minimum Gas Rate for Stripping")
        }

        private func calculate() {
            result = nil
            errorMessage = ""

            do {
                result = try engine.calculate(
                    .init(
                            liquidMolarFlow: try InputValidator.parseNumber(
                            liquidFlowInput,
                            fieldName: "liquid molar flow"
                        ),
                        inletLiquidSoluteFraction: try InputValidator.parseNumber(
                            xinInput,
                            fieldName: "inlet liquid solute fraction"
                        ),
                        outletLiquidSoluteFraction: try InputValidator.parseNumber(
                            xoutInput,
                            fieldName: "outlet liquid solute fraction"
                        ),
                        enteringGasSoluteFraction: try InputValidator.parseNumber(
                            yinInput,
                            fieldName: "entering gas solute fraction"
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
            liquidFlowInput = ""
        xinInput = ""
        xoutInput = ""
        yinInput = ""
        slopeInput = ""
        factorInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { StrippingMinimumGasRateView() }
    }
