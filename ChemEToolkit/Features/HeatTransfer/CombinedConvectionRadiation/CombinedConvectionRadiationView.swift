import SwiftUI

struct CombinedConvectionRadiationView: View {

    @State
    private var heatTransferCoefficientInput = "10"

    @State private var emissivityInput = "0.8"
    @State private var areaInput = "2"

    @State
    private var surfaceTemperatureInput = "100"

    @State
    private var fluidTemperatureInput = "20"

    @State
    private var surroundingsTemperatureInput = "20"

    @State
    private var result:
        CombinedConvectionRadiationResult?

    @State private var errorMessage = ""

    private let engine =
        CombinedConvectionRadiationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "sun.max.trianglebadge.exclamationmark",
                    title:
                        "Combined Convection & Radiation",
                    subtitle:
                        "Calculate total surface heat transfer by two simultaneous modes",
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
        .navigationTitle(
            "Combined Convection & Radiation"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Combined Surface Heat Transfer")
                    .font(.headline)

                Text(
                    "Q̇ₜ = hA(Tₛ − T∞) + εσA(Tₛ⁴ − Tₛᵤᵣ⁴)"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)
                .multilineTextAlignment(.center)

                Text(
                    """
                    Convection and radiation are calculated \
                    separately before their signed heat rates \
                    are combined.
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
            Text("Surface Properties")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Convective Coefficient",
                symbol: "h",
                unit: "W/(m²·K)",
                placeholder: "Example: 10",
                text:
                    $heatTransferCoefficientInput
            )

            EngineeringInputField(
                title: "Surface Emissivity",
                symbol: "ε",
                unit: "—",
                placeholder: "Example: 0.8",
                text: $emissivityInput
            )

            EngineeringInputField(
                title: "Surface Area",
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
                title: "Fluid Temperature",
                symbol: "T∞",
                unit: "°C",
                placeholder: "Example: 20",
                text:
                    $fluidTemperatureInput
            )

            EngineeringInputField(
                title:
                    "Surroundings Temperature",
                symbol: "Tₛᵤᵣ",
                unit: "°C",
                placeholder: "Example: 20",
                text:
                    $surroundingsTemperatureInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Combined Transfer",
                systemImage:
                    "sun.max.trianglebadge.exclamationmark",
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
        _ result:
            CombinedConvectionRadiationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Total Heat Transfer",
                        value:
                            numberFormatter.format(
                                result
                                    .totalHeatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Convection Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .convectionHeatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Radiation Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .radiationHeatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label: "Total Heat Flux",
                        value:
                            numberFormatter.format(
                                result.totalHeatFlux
                            ),
                        unit: "W/m²"
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
                        "Mode Comparison",
                        systemImage:
                            "arrow.triangle.branch"
                    )
                    .font(.headline)

                    Divider()

                    informationRow(
                        title: "Net Direction",
                        value:
                            result.direction.description
                    )

                    informationRow(
                        title: "Dominant Mode",
                        value:
                            result.dominantMode.description
                    )

                    informationRow(
                        title: "Modes Oppose",
                        value:
                            result.modesOppose
                            ? "Yes"
                            : "No"
                    )

                    informationRow(
                        title:
                            "Radiation Coefficient",
                        value:
                            "\(numberFormatter.format(result.effectiveRadiationCoefficient)) W/(m²·K)"
                    )

                    informationRow(
                        title:
                            "Convection ΔT",
                        value:
                            "\(numberFormatter.format(result.convectionTemperatureDifference)) K"
                    )

                    informationRow(
                        title:
                            "Radiation ΔT",
                        value:
                            "\(numberFormatter.format(result.radiationTemperatureDifference)) K"
                    )
                }
            }
        }
    }

    private func resultColor(
        for direction:
            CombinedHeatFlowDirection
    ) -> Color {

        switch direction {
        case .surfaceToEnvironment:
            return .orange

        case .environmentToSurface:
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
        -> CombinedConvectionRadiationInput {

        CombinedConvectionRadiationInput(
            heatTransferCoefficient:
                try InputValidator.parseNumber(
                    heatTransferCoefficientInput,
                    fieldName:
                        "heat-transfer coefficient"
                ),
            emissivity:
                try InputValidator.parseNumber(
                    emissivityInput,
                    fieldName: "emissivity"
                ),
            area:
                try InputValidator.parseNumber(
                    areaInput,
                    fieldName:
                        "heat-transfer area"
                ),
            surfaceTemperature:
                try InputValidator.parseNumber(
                    surfaceTemperatureInput,
                    fieldName:
                        "surface temperature"
                ),
            fluidTemperature:
                try InputValidator.parseNumber(
                    fluidTemperatureInput,
                    fieldName:
                        "fluid temperature"
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
        heatTransferCoefficientInput = "10"
        emissivityInput = "0.8"
        areaInput = "2"
        surfaceTemperatureInput = "100"
        fluidTemperatureInput = "20"
        surroundingsTemperatureInput = "20"

        clearResult()
    }

    private func resetInputs() {
        heatTransferCoefficientInput = ""
        emissivityInput = ""
        areaInput = ""
        surfaceTemperatureInput = ""
        fluidTemperatureInput = ""
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
        CombinedConvectionRadiationView()
    }
}
