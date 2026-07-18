import SwiftUI

    struct CycloneCutDiameterView: View {
        @State private var viscosityInput = "0.000018"

    @State private var widthInput = "0.20"

    @State private var turnsInput = "5"

    @State private var particleDensityInput = "2500"

    @State private var gasDensityInput = "1.2"

    @State private var velocityInput = "15"

        @State private var result: CycloneCutDiameterResult?
        @State private var errorMessage = ""

        private let engine = CycloneCutDiameterEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "tornado",
                        title: "Cyclone Cut Diameter",
                        subtitle: "Estimate the 50% collection particle size",
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
                        title: "Gas Viscosity",
                        symbol: "mu",
                        unit: "Pa·s",
                        placeholder: "0.000018",
                        text: $viscosityInput
                    )

                    EngineeringInputField(
                        title: "Cyclone Inlet Width",
                        symbol: "b",
                        unit: "m",
                        placeholder: "0.20",
                        text: $widthInput
                    )

                    EngineeringInputField(
                        title: "Effective Turns",
                        symbol: "N_e",
                        unit: "—",
                        placeholder: "5",
                        text: $turnsInput
                    )

                    EngineeringInputField(
                        title: "Particle Density",
                        symbol: "rho_p",
                        unit: "kg/m³",
                        placeholder: "2500",
                        text: $particleDensityInput
                    )

                    EngineeringInputField(
                        title: "Gas Density",
                        symbol: "rho_g",
                        unit: "kg/m³",
                        placeholder: "1.2",
                        text: $gasDensityInput
                    )

                    EngineeringInputField(
                        title: "Inlet Velocity",
                        symbol: "v_i",
                        unit: "m/s",
                        placeholder: "15",
                        text: $velocityInput
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
                                systemImage: "tornado",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Cut Diameter",
                                value: numberFormatter.format(result.cutDiameter),
                                unit: "m"
                            ),
.init(
                                label: "Density Difference",
                                value: numberFormatter.format(result.densityDifference),
                                unit: "kg/m³"
                            ),
.init(
                                label: "Centrifugal Exposure",
                                value: numberFormatter.format(result.centrifugalExposure),
                                unit: "1/s"
                            ),
.init(
                                label: "Particle Relaxation Time",
                                value: numberFormatter.format(result.particleRelaxationTime),
                                unit: "s"
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
            .navigationTitle("Cyclone Cut Diameter")
        }

        private func calculate() {
            result = nil
            errorMessage = ""

            do {
                result = try engine.calculate(
                    .init(
                            gasViscosity: try InputValidator.parseNumber(
                            viscosityInput,
                            fieldName: "gas viscosity"
                        ),
                        inletWidth: try InputValidator.parseNumber(
                            widthInput,
                            fieldName: "cyclone inlet width"
                        ),
                        effectiveTurns: try InputValidator.parseNumber(
                            turnsInput,
                            fieldName: "effective turns"
                        ),
                        particleDensity: try InputValidator.parseNumber(
                            particleDensityInput,
                            fieldName: "particle density"
                        ),
                        gasDensity: try InputValidator.parseNumber(
                            gasDensityInput,
                            fieldName: "gas density"
                        ),
                        inletVelocity: try InputValidator.parseNumber(
                            velocityInput,
                            fieldName: "inlet velocity"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            viscosityInput = ""
        widthInput = ""
        turnsInput = ""
        particleDensityInput = ""
        gasDensityInput = ""
        velocityInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { CycloneCutDiameterView() }
    }
