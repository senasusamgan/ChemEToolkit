import SwiftUI

struct ThermalRadiationView: View {

    @State private var emissivityInput = "0.8"
    @State private var areaInput = "2"
    @State private var surfaceTemperatureInput = "100"
    @State private var surroundingsTemperatureInput = "20"

    @State
    private var result:
        ThermalRadiationResult?

    @State private var errorMessage = ""

    private let engine =
        ThermalRadiationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "sun.max.fill",
                    title: "Thermal Radiation",
                    subtitle:
                        "Net radiation between a surface and large surroundings",
                    tint: .orange
                )

                formulaCard

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
        .navigationTitle("Thermal Radiation")
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Stefan–Boltzmann Law")
                    .font(.headline)

                Text(
                    "Q̇ = εσA(Tₛ⁴ − Tₛᵤᵣ⁴)"
                )
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)

                Text(
                    "σ = 5.670374419 × 10⁻⁸ W/(m²·K⁴)"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Text(
                    """
                    Temperatures are entered in Celsius and \
                    converted internally to absolute temperature.
                    """
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
            Text("Radiation Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Surface Emissivity",
                symbol: "ε",
                unit: "—",
                placeholder: "Example: 0.8",
                text: $emissivityInput
            )

            EngineeringInputField(
                title: "Radiating Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 2",
                text: $areaInput
            )

            Divider()

            Text("Temperatures")
                .font(.headline)

            EngineeringInputField(
                title: "Surface Temperature",
                symbol: "Tₛ",
                unit: "°C",
                placeholder: "Example: 100",
                text:
                    $surfaceTemperatureInput
            )

            EngineeringInputField(
                title: "Surroundings Temperature",
                symbol: "Tₛᵤᵣ",
                unit: "°C",
                placeholder: "Example: 20",
                text:
                    $surroundingsTemperatureInput
            )

            actionButtons

            PrimaryActionButton(
                title: "Calculate Radiation",
                systemImage: "sun.max.fill",
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
        Button(action: loadExample) {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearButton: some View {
        Button(action: resetInputs) {
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
        _ result: ThermalRadiationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Net Radiation Rate",
                        value:
                            numberFormatter.format(
                                result.heatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Radiation Magnitude",
                        value:
                            numberFormatter.format(
                                result
                                    .heatTransferRateMagnitude
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label: "Radiation Heat Flux",
                        value:
                            numberFormatter.format(
                                result.heatFlux
                            ),
                        unit: "W/m²"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Effective Radiation Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .effectiveRadiationCoefficient
                            ),
                        unit: "W/(m²·K)"
                    )
                ],
                tint:
                    resultColor(
                        for: result.direction
                    )
            )

            CalculatorInfoCard(
                tint:
                    resultColor(
                        for: result.direction
                    )
            ) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        "Radiation Interpretation",
                        systemImage: "sun.max.fill"
                    )
                    .font(.headline)

                    Divider()

                    informationRow(
                        title: "Direction",
                        value:
                            result.direction.description
                    )

                    informationRow(
                        title: "Surface Temperature",
                        value:
                            "\(numberFormatter.format(result.surfaceTemperatureKelvin)) K"
                    )

                    informationRow(
                        title: "Surroundings Temperature",
                        value:
                            "\(numberFormatter.format(result.surroundingsTemperatureKelvin)) K"
                    )

                    informationRow(
                        title: "Temperature Difference",
                        value:
                            "\(numberFormatter.format(result.temperatureDifference)) K"
                    )
                }
            }
        }
    }

    private func resultColor(
        for direction:
            RadiationHeatFlowDirection
    ) -> Color {

        switch direction {
        case .surfaceToSurroundings:
            return .orange

        case .surroundingsToSurface:
            return .blue

        case .equilibrium:
            return .green
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
                .multilineTextAlignment(.trailing)
        }
    }

    private func calculate() {
        clearResult()

        do {
            result =
                try engine.calculate(
                    input: try makeInput()
                )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> ThermalRadiationInput {

        ThermalRadiationInput(
            emissivity:
                try InputValidator.parseNumber(
                    emissivityInput,
                    fieldName: "emissivity"
                ),
            area:
                try InputValidator.parseNumber(
                    areaInput,
                    fieldName:
                        "radiating area"
                ),
            surfaceTemperature:
                try InputValidator.parseNumber(
                    surfaceTemperatureInput,
                    fieldName:
                        "surface temperature"
                ),
            surroundingsTemperature:
                try InputValidator.parseNumber(
                    surroundingsTemperatureInput,
                    fieldName:
                        "surroundings temperature"
                )
        )
    }

    private func loadExample() {
        emissivityInput = "0.8"
        areaInput = "2"
        surfaceTemperatureInput = "100"
        surroundingsTemperatureInput = "20"

        clearResult()
    }

    private func resetInputs() {
        emissivityInput = ""
        areaInput = ""
        surfaceTemperatureInput = ""
        surroundingsTemperatureInput = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription
            ?? "The entered values could not be processed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ThermalRadiationView()
    }
}
