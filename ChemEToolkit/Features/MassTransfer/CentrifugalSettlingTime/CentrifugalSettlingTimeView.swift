import SwiftUI

struct CentrifugalSettlingTimeView:
    View {

    @State
    private var particleDiameterInput =
        "0.000004"

    @State
    private var particleDensityInput =
        "2500"

    @State
    private var fluidDensityInput =
        "1000"

    @State
    private var viscosityInput = "0.001"

    @State
    private var rpmInput = "3000"

    @State
    private var initialRadiusInput =
        "0.05"

    @State
    private var finalRadiusInput =
        "0.15"

    @State
    private var result:
        CentrifugalSettlingTimeResult?

    @State
    private var errorMessage = ""

    private let engine =
        CentrifugalSettlingTimeEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.triangle.2.circlepath.circle.fill",
                    title:
                        "Centrifugal Settling Time",
                    subtitle:
                        "Calculate radial migration time and Stokes-regime validity",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text(
                            "Stokes Settling in a Centrifugal Field"
                        )
                        .font(.headline)

                        Text(
                            "dr/dt = [dp²(ρp − ρf)ω²/(18μ)]r"
                        )
                        .font(
                            .system(
                                size: 15,
                                weight: .semibold
                            )
                        )
                        .minimumScaleFactor(0.4)
                        .multilineTextAlignment(.center)

                        Text(
                            "t = ln(r₂/r₁) / k, where k = dp²Δρω²/(18μ)"
                        )
                        .font(
                            .system(
                                size: 15,
                                weight: .semibold
                            )
                        )
                        .minimumScaleFactor(0.4)
                        .multilineTextAlignment(.center)

                        Text(
                            """
                            The model checks the outer-radius particle Reynolds \
                            number and requires Reₚ ≤ 0.20.
                            """
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    calculatorContent
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
        .navigationTitle(
            "Centrifugal Settling"
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Particle and Fluid")
                .font(.headline)

            EngineeringInputField(
                title: "Particle Diameter",
                symbol: "dp",
                unit: "m",
                placeholder: "Example: 4e-6",
                text: $particleDiameterInput
            )

            EngineeringInputField(
                title: "Particle Density",
                symbol: "ρp",
                unit: "kg/m³",
                placeholder: "Example: 2500",
                text: $particleDensityInput
            )

            EngineeringInputField(
                title: "Fluid Density",
                symbol: "ρf",
                unit: "kg/m³",
                placeholder: "Example: 1000",
                text: $fluidDensityInput
            )

            EngineeringInputField(
                title: "Fluid Viscosity",
                symbol: "μ",
                unit: "Pa·s",
                placeholder: "Example: 0.001",
                text: $viscosityInput
            )

            Divider()

            Text("Rotor Geometry")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Rotational Speed",
                symbol: "N",
                unit: "rpm",
                placeholder: "Example: 3000",
                text: $rpmInput
            )

            EngineeringInputField(
                title: "Initial Radius",
                symbol: "r₁",
                unit: "m",
                placeholder: "Example: 0.05",
                text: $initialRadiusInput
            )

            EngineeringInputField(
                title: "Final Radius",
                symbol: "r₂",
                unit: "m",
                placeholder: "Example: 0.15",
                text: $finalRadiusInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Settling Time",
                systemImage:
                    "arrow.triangle.2.circlepath.circle.fill",
                action: calculate
            )

            if let result {
                resultSection(result)
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private func resultSection(
        _ result:
            CentrifugalSettlingTimeResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    .init(
                        label:
                            "Angular Velocity",
                        value:
                            numberFormatter.format(
                                result.angularVelocity
                            ),
                        unit: "rad/s"
                    ),
                    .init(
                        label:
                            "Radial Response Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .radialResponseCoefficient
                            ),
                        unit: "1/s"
                    ),
                    .init(
                        label:
                            "Inner Radial Velocity",
                        value:
                            numberFormatter.format(
                                result
                                    .innerRadialVelocity
                            ),
                        unit: "m/s"
                    ),
                    .init(
                        label:
                            "Outer Radial Velocity",
                        value:
                            numberFormatter.format(
                                result
                                    .outerRadialVelocity
                            ),
                        unit: "m/s"
                    ),
                    .init(
                        label:
                            "Migration Distance",
                        value:
                            numberFormatter.format(
                                result
                                    .migrationDistance
                            ),
                        unit: "m"
                    ),
                    .init(
                        label:
                            "Migration Time",
                        value:
                            numberFormatter.format(
                                result.migrationTime
                            ),
                        unit: "s"
                    ),
                    .init(
                        label:
                            "Outer Acceleration",
                        value:
                            numberFormatter.format(
                                result
                                    .outerCentrifugalAcceleration
                            ),
                        unit: "m/s²"
                    ),
                    .init(
                        label:
                            "Outer Relative Centrifugal Force",
                        value:
                            numberFormatter.format(
                                result
                                    .outerRelativeCentrifugalForce
                            ),
                        unit: "×g"
                    ),
                    .init(
                        label:
                            "Outer Particle Reynolds Number",
                        value:
                            numberFormatter.format(
                                result
                                    .outerParticleReynoldsNumber
                            ),
                        unit: "—"
                    ),
                    .init(
                        label:
                            "Density Difference",
                        value:
                            numberFormatter.format(
                                result.densityDifference
                            ),
                        unit: "kg/m³"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
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
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> CentrifugalSettlingTimeInput {

        .init(
            particleDiameter:
                try InputValidator.parseNumber(
                    particleDiameterInput,
                    fieldName:
                        "particle diameter"
                ),
            particleDensity:
                try InputValidator.parseNumber(
                    particleDensityInput,
                    fieldName:
                        "particle density"
                ),
            fluidDensity:
                try InputValidator.parseNumber(
                    fluidDensityInput,
                    fieldName:
                        "fluid density"
                ),
            fluidViscosity:
                try InputValidator.parseNumber(
                    viscosityInput,
                    fieldName:
                        "fluid viscosity"
                ),
            rotationalSpeedRPM:
                try InputValidator.parseNumber(
                    rpmInput,
                    fieldName:
                        "rotational speed"
                ),
            initialRadius:
                try InputValidator.parseNumber(
                    initialRadiusInput,
                    fieldName:
                        "initial radius"
                ),
            finalRadius:
                try InputValidator.parseNumber(
                    finalRadiusInput,
                    fieldName:
                        "final radius"
                )
        )
    }

    private func loadExample() {
        particleDiameterInput =
            "0.000004"
        particleDensityInput = "2500"
        fluidDensityInput = "1000"
        viscosityInput = "0.001"
        rpmInput = "3000"
        initialRadiusInput = "0.05"
        finalRadiusInput = "0.15"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        particleDiameterInput = ""
        particleDensityInput = ""
        fluidDensityInput = ""
        viscosityInput = ""
        rpmInput = ""
        initialRadiusInput = ""
        finalRadiusInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CentrifugalSettlingTimeView()
    }
}
