import SwiftUI

struct ParticleSettlingView: View {

    @State private var particleDensityText = "2500"
    @State private var fluidDensityText = "998"
    @State private var diameterText = "0.0001"
    @State private var viscosityText = "0.001"
    @State private var gravityText = "9.80665"

    @State
    private var calculationResult:
        ParticleSettlingResult?

    @State private var errorMessage = ""

    private let engine =
        ParticleSettlingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.down.circle.fill",
                    title:
                        "Particle Settling",
                    subtitle:
                        "Estimate terminal velocity using Stokes law",
                    tint:
                        .brown
                )

                equationInformationCard

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(maxWidth: .infinity)
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle(
            "Particle Settling"
        )
    }

    private var equationInformationCard:
        some View {
        CalculatorInfoCard(tint: .brown) {
            VStack(spacing: AppSpacing.small) {
                Text("Stokes Terminal Velocity")
                    .font(.headline)

                Text(
                    "vₜ = (ρₚ − ρ𝒇)gdₚ² / 18μ"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)

                Text(
                    "Reₚ = ρ𝒇|vₜ|dₚ / μ"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )

                Text(
                    "Stokes law is normally appropriate only when the particle Reynolds number is below approximately one."
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(
            maxWidth:
                AppTheme.Layout.calculatorMaxWidth
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Particle & Fluid Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Particle Density",
                symbol: "ρₚ",
                unit: "kg/m³",
                placeholder: "Example: 2500",
                text: $particleDensityText
            )

            EngineeringInputField(
                title: "Fluid Density",
                symbol: "ρ𝒇",
                unit: "kg/m³",
                placeholder: "Example: 998",
                text: $fluidDensityText
            )

            EngineeringInputField(
                title: "Particle Diameter",
                symbol: "dₚ",
                unit: "m",
                placeholder: "Example: 0.0001",
                text: $diameterText
            )

            EngineeringInputField(
                title: "Dynamic Viscosity",
                symbol: "μ",
                unit: "Pa·s",
                placeholder: "Example: 0.001",
                text: $viscosityText
            )

            DisclosureGroup("Advanced Inputs") {
                EngineeringInputField(
                    title:
                        "Gravitational Acceleration",
                    symbol: "g",
                    unit: "m/s²",
                    placeholder:
                        "Example: 9.80665",
                    text: $gravityText
                )
                .padding(
                    .top,
                    AppSpacing.medium
                )
            }
            .font(.headline)

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Terminal Velocity",
                systemImage: "equal.circle",
                action: calculate
            )

            if let calculationResult {
                resultSection(calculationResult)
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var actionButtons: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: AppSpacing.small) {
                loadExampleButton
                clearButton
            }

            VStack(spacing: AppSpacing.small) {
                loadExampleButton
                clearButton
            }
        }
    }

    private var loadExampleButton: some View {
        Button {
            loadExample()
        } label: {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearButton: some View {
        Button {
            resetInputs()
        } label: {
            Label(
                "Clear",
                systemImage:
                    "arrow.counterclockwise"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result:
            ParticleSettlingResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Terminal Speed",
                        value: numberFormatter.format(
                            result.terminalSpeed
                        ),
                        unit: "m/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Terminal Speed",
                        value: numberFormatter.format(
                            result
                                .terminalSpeedMillimetresPerSecond
                        ),
                        unit: "mm/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Particle Reynolds Number",
                        value: numberFormatter.format(
                            result
                                .particleReynoldsNumber
                        ),
                        unit: ""
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Motion Direction",
                        value: directionTitle(
                            result.motionDirection
                        ),
                        unit: ""
                    )
                ]
            )

            CalculatorInfoCard(
                tint:
                    result.isWithinStokesRegime
                    ? .green
                    : .orange
            ) {
                VStack(spacing: AppSpacing.small) {
                    Text(
                        result.isWithinStokesRegime
                        ? "Stokes Regime Valid"
                        : "Stokes Regime Warning"
                    )
                    .font(.headline)

                    Text(
                        validityExplanation(result)
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                    Divider()

                    informationRow(
                        title: "Density difference",
                        value: numberFormatter.format(
                            result.densityDifference,
                            unit: "kg/m³"
                        )
                    )

                    informationRow(
                        title: "Particle diameter",
                        value: numberFormatter.format(
                            result.particleDiameter,
                            unit: "m"
                        )
                    )
                }
            }
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }

    private func directionTitle(
        _ direction:
            ParticleMotionDirection
    ) -> String {
        switch direction {
        case .settling:
            return "Settling"

        case .rising:
            return "Rising"

        case .neutral:
            return "Neutral"
        }
    }

    private func validityExplanation(
        _ result:
            ParticleSettlingResult
    ) -> String {
        if result.isWithinStokesRegime {
            return
                "The calculated particle Reynolds number is below one, so the Stokes-law assumption is reasonable."
        }

        return
            "The calculated particle Reynolds number exceeds one. The displayed velocity is only a Stokes-law estimate; a general drag correlation should be used."
    }

    private func calculate() {
        clearResult()

        do {
            calculationResult = try engine.solve(
                input: try makeInput()
            )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch let error
            as ParticleSettlingError {
            errorMessage =
                error.errorDescription
                ?? "The terminal velocity could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> ParticleSettlingInput {
        ParticleSettlingInput(
            particleDensity: try parsePositive(
                particleDensityText,
                fieldName: "Particle Density"
            ),
            fluidDensity: try parsePositive(
                fluidDensityText,
                fieldName: "Fluid Density"
            ),
            particleDiameter: try parsePositive(
                diameterText,
                fieldName: "Particle Diameter"
            ),
            dynamicViscosity: try parsePositive(
                viscosityText,
                fieldName: "Dynamic Viscosity"
            ),
            gravity: try parsePositive(
                gravityText,
                fieldName:
                    "Gravitational Acceleration"
            )
        )
    }

    private func parsePositive(
        _ text: String,
        fieldName: String
    ) throws -> Double {
        let value =
            try InputValidator.parseNumber(
                text,
                fieldName: fieldName
            )

        return try InputValidator.requirePositive(
            value,
            fieldName: fieldName
        )
    }

    private func loadExample() {
        particleDensityText = "2500"
        fluidDensityText = "998"
        diameterText = "0.0001"
        viscosityText = "0.001"
        gravityText = "9.80665"

        clearResult()
    }

    private func resetInputs() {
        particleDensityText = ""
        fluidDensityText = ""
        diameterText = ""
        viscosityText = ""
        gravityText = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription
            ?? "The inputs could not be processed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        calculationResult = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ParticleSettlingView()
    }
}
