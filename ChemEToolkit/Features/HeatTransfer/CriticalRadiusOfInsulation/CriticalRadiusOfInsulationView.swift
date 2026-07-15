import SwiftUI

struct CriticalRadiusOfInsulationView: View {

    @State
    private var thermalConductivityInput =
        "0.05"

    @State
    private var heatTransferCoefficientInput =
        "10"

    @State private var innerRadiusInput = "0.002"
    @State private var outerRadiusInput = "0.004"
    @State private var cylinderLengthInput = "1"

    @State
    private var innerTemperatureInput = "100"

    @State
    private var ambientTemperatureInput = "20"

    @State
    private var result:
        CriticalRadiusOfInsulationResult?

    @State private var errorMessage = ""

    private let engine =
        CriticalRadiusOfInsulationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "circle.dashed.inset.filled",
                    title:
                        "Critical Radius of Insulation",
                    subtitle:
                        "Analyze insulation resistance and cylindrical heat loss",
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
            "Critical Radius of Insulation"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Critical Radius for a Cylinder"
                )
                .font(.headline)

                Text("r𝚌 = k/h")
                    .font(
                        .system(
                            size: 23,
                            weight: .semibold
                        )
                    )

                Text(
                    "Rₜ = ln(rₒ/rᵢ)/(2πkL) + 1/(h2πrₒL)"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)
                .multilineTextAlignment(.center)

                Text(
                    """
                    Below the critical radius, the increased \
                    convection area can initially outweigh \
                    the added conduction resistance.
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
            Text("Material and Convection")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Insulation Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 0.05",
                text:
                    $thermalConductivityInput
            )

            EngineeringInputField(
                title:
                    "External Heat-Transfer Coefficient",
                symbol: "h",
                unit: "W/(m²·K)",
                placeholder: "Example: 10",
                text:
                    $heatTransferCoefficientInput
            )

            Divider()

            Text("Cylindrical Geometry")
                .font(.headline)

            EngineeringInputField(
                title: "Inner Radius",
                symbol: "rᵢ",
                unit: "m",
                placeholder: "Example: 0.002",
                text: $innerRadiusInput
            )

            EngineeringInputField(
                title: "Outer Radius",
                symbol: "rₒ",
                unit: "m",
                placeholder: "Example: 0.004",
                text: $outerRadiusInput
            )

            EngineeringInputField(
                title: "Cylinder Length",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 1",
                text: $cylinderLengthInput
            )

            Divider()

            Text("Temperatures")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Inner-Surface Temperature",
                symbol: "Tᵢ",
                unit: "°C",
                placeholder: "Example: 100",
                text:
                    $innerTemperatureInput
            )

            EngineeringInputField(
                title: "Ambient Temperature",
                symbol: "T∞",
                unit: "°C",
                placeholder: "Example: 20",
                text:
                    $ambientTemperatureInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Critical Radius",
                systemImage:
                    "circle.dashed.inset.filled",
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
            CriticalRadiusOfInsulationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Critical Radius",
                        value:
                            numberFormatter.format(
                                result.criticalRadius
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Current Heat Transfer",
                        value:
                            numberFormatter.format(
                                result
                                    .currentHeatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .totalThermalResistance
                            ),
                        unit: "K/W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Maximum Heat Transfer",
                        value:
                            numberFormatter.format(
                                result
                                    .maximumHeatTransferRate
                            ),
                        unit: "W"
                    )
                ],
                tint: .orange
            )

            CalculatorInfoCard(tint: .orange) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        "Insulation Interpretation",
                        systemImage:
                            "circle.dashed.inset.filled"
                    )
                    .font(.headline)

                    Divider()

                    informationRow(
                        title:
                            "Conduction Resistance",
                        value:
                            "\(numberFormatter.format(result.conductionResistance)) K/W"
                    )

                    informationRow(
                        title:
                            "Convection Resistance",
                        value:
                            "\(numberFormatter.format(result.convectionResistance)) K/W"
                    )

                    informationRow(
                        title:
                            "Maximum-Transfer Radius",
                        value:
                            "\(numberFormatter.format(result.maximumHeatTransferRadius)) m"
                    )

                    Text(result.regime.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
        } catch let error
            as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> CriticalRadiusOfInsulationInput {

        CriticalRadiusOfInsulationInput(
            insulationThermalConductivity:
                try InputValidator.parseNumber(
                    thermalConductivityInput,
                    fieldName:
                        "insulation conductivity"
                ),
            externalHeatTransferCoefficient:
                try InputValidator.parseNumber(
                    heatTransferCoefficientInput,
                    fieldName:
                        "external heat-transfer coefficient"
                ),
            innerRadius:
                try InputValidator.parseNumber(
                    innerRadiusInput,
                    fieldName: "inner radius"
                ),
            outerRadius:
                try InputValidator.parseNumber(
                    outerRadiusInput,
                    fieldName: "outer radius"
                ),
            cylinderLength:
                try InputValidator.parseNumber(
                    cylinderLengthInput,
                    fieldName:
                        "cylinder length"
                ),
            innerSurfaceTemperature:
                try InputValidator.parseNumber(
                    innerTemperatureInput,
                    fieldName:
                        "inner-surface temperature"
                ),
            ambientTemperature:
                try InputValidator.parseNumber(
                    ambientTemperatureInput,
                    fieldName:
                        "ambient temperature"
                )
        )
    }

    private func loadExample() {
        thermalConductivityInput = "0.05"
        heatTransferCoefficientInput = "10"
        innerRadiusInput = "0.002"
        outerRadiusInput = "0.004"
        cylinderLengthInput = "1"
        innerTemperatureInput = "100"
        ambientTemperatureInput = "20"

        clearResult()
    }

    private func resetInputs() {
        thermalConductivityInput = ""
        heatTransferCoefficientInput = ""
        innerRadiusInput = ""
        outerRadiusInput = ""
        cylinderLengthInput = ""
        innerTemperatureInput = ""
        ambientTemperatureInput = ""

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
        CriticalRadiusOfInsulationView()
    }
}
