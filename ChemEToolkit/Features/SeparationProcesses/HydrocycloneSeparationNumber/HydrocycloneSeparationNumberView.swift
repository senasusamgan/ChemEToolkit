import SwiftUI

    struct HydrocycloneSeparationNumberView: View {
        @State private var diameterInput = "0.00005"

    @State private var particleDensityInput = "2500"

    @State private var liquidDensityInput = "1000"

    @State private var viscosityInput = "0.001"

    @State private var velocityInput = "10"

    @State private var radiusInput = "0.10"

        @State private var result: HydrocycloneSeparationNumberResult?
        @State private var errorMessage = ""

        private let engine = HydrocycloneSeparationNumberEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "drop.circle.fill",
                        title: "Hydrocyclone Separation Number",
                        subtitle: "Calculate a centrifugal settling performance index",
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
                        title: "Particle Diameter",
                        symbol: "d_p",
                        unit: "m",
                        placeholder: "0.00005",
                        text: $diameterInput
                    )

                    EngineeringInputField(
                        title: "Particle Density",
                        symbol: "rho_p",
                        unit: "kg/m³",
                        placeholder: "2500",
                        text: $particleDensityInput
                    )

                    EngineeringInputField(
                        title: "Liquid Density",
                        symbol: "rho_l",
                        unit: "kg/m³",
                        placeholder: "1000",
                        text: $liquidDensityInput
                    )

                    EngineeringInputField(
                        title: "Liquid Viscosity",
                        symbol: "mu",
                        unit: "Pa·s",
                        placeholder: "0.001",
                        text: $viscosityInput
                    )

                    EngineeringInputField(
                        title: "Tangential Velocity",
                        symbol: "v_t",
                        unit: "m/s",
                        placeholder: "10",
                        text: $velocityInput
                    )

                    EngineeringInputField(
                        title: "Cyclone Radius",
                        symbol: "r",
                        unit: "m",
                        placeholder: "0.10",
                        text: $radiusInput
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
                                systemImage: "drop.circle.fill",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Radial Settling Velocity",
                                value: numberFormatter.format(result.radialSettlingVelocity),
                                unit: "m/s"
                            ),
.init(
                                label: "Separation Number",
                                value: numberFormatter.format(result.separationNumber),
                                unit: "—"
                            ),
.init(
                                label: "Centrifugal Acceleration",
                                value: numberFormatter.format(result.centrifugalAcceleration),
                                unit: "m/s²"
                            ),
.init(
                                label: "Centrifugal G-Force",
                                value: numberFormatter.format(result.centrifugalGForce),
                                unit: "g"
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
            .navigationTitle("Hydrocyclone Separation Number")
        }

        private func calculate() {
            result = nil
            errorMessage = ""

            do {
                result = try engine.calculate(
                    .init(
                            particleDiameter: try InputValidator.parseNumber(
                            diameterInput,
                            fieldName: "particle diameter"
                        ),
                        particleDensity: try InputValidator.parseNumber(
                            particleDensityInput,
                            fieldName: "particle density"
                        ),
                        liquidDensity: try InputValidator.parseNumber(
                            liquidDensityInput,
                            fieldName: "liquid density"
                        ),
                        liquidViscosity: try InputValidator.parseNumber(
                            viscosityInput,
                            fieldName: "liquid viscosity"
                        ),
                        tangentialVelocity: try InputValidator.parseNumber(
                            velocityInput,
                            fieldName: "tangential velocity"
                        ),
                        cycloneRadius: try InputValidator.parseNumber(
                            radiusInput,
                            fieldName: "cyclone radius"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            diameterInput = ""
        particleDensityInput = ""
        liquidDensityInput = ""
        viscosityInput = ""
        velocityInput = ""
        radiusInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { HydrocycloneSeparationNumberView() }
    }
