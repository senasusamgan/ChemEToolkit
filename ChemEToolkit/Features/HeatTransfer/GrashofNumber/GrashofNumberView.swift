import SwiftUI

struct GrashofNumberView: View {

    @State
    private var gravityInput = "9.80665"

    @State
    private var expansionCoefficientInput = "0.0033"

    @State
    private var surfaceTemperatureInput = "100"

    @State
    private var fluidTemperatureInput = "20"

    @State
    private var characteristicLengthInput = "0.5"

    @State
    private var kinematicViscosityInput = "0.000015"

    @State
    private var result: GrashofNumberResult?

    @State
    private var errorMessage = ""

    private let engine = GrashofNumberEngine()
    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        DimensionlessNumberCalculatorView(
            symbolName: "arrow.up.to.line",
            title: "Grashof Number",
            subtitle:
                "Compare buoyancy and viscous forces in natural convection",
            formulaTitle: "Grashof Number",
            formula: "Gr = gβ|Tₛ − T∞|L𝚌³ / ν²",
            explanation:
                "A natural-convection parameter based on buoyancy, geometry and viscous resistance.",
            fields: [
                .init(
                    id: "g",
                    title:
                        "Gravitational Acceleration",
                    symbol: "g",
                    unit: "m/s²",
                    placeholder: "Example: 9.80665",
                    text: $gravityInput
                ),
                .init(
                    id: "beta",
                    title:
                        "Thermal Expansion Coefficient",
                    symbol: "β",
                    unit: "1/K",
                    placeholder: "Example: 0.0033",
                    text:
                        $expansionCoefficientInput
                ),
                .init(
                    id: "surface",
                    title: "Surface Temperature",
                    symbol: "Tₛ",
                    unit: "°C",
                    placeholder: "Example: 100",
                    text:
                        $surfaceTemperatureInput
                ),
                .init(
                    id: "fluid",
                    title: "Fluid Temperature",
                    symbol: "T∞",
                    unit: "°C",
                    placeholder: "Example: 20",
                    text: $fluidTemperatureInput
                ),
                .init(
                    id: "length",
                    title: "Characteristic Length",
                    symbol: "L𝚌",
                    unit: "m",
                    placeholder: "Example: 0.5",
                    text: $characteristicLengthInput
                ),
                .init(
                    id: "nu",
                    title: "Kinematic Viscosity",
                    symbol: "ν",
                    unit: "m²/s",
                    placeholder: "Example: 0.000015",
                    text: $kinematicViscosityInput
                )
            ],
            calculateTitle:
                "Calculate Grashof Number",
            calculateSystemImage:
                "arrow.up.to.line",
            resultItems: resultItems,
            interpretationTitle:
                "Buoyancy Interpretation",
            interpretationSystemImage:
                "wind",
            informationRows: informationRows,
            interpretationText:
                result?.buoyancyDirection.description
                ?? "",
            errorMessage: errorMessage,
            loadExample: loadExample,
            clear: resetInputs,
            calculate: calculate
        )
    }

    private var resultItems:
        [CalculationResultDisplayItem] {

        guard let result else {
            return []
        }

        return [
            CalculationResultDisplayItem(
                label: "Grashof Number",
                value:
                    formatter.format(
                        result.grashofNumber
                    ),
                unit: "—"
            ),
            CalculationResultDisplayItem(
                label:
                    "Temperature Difference",
                value:
                    formatter.format(
                        result
                            .temperatureDifferenceMagnitude
                    ),
                unit: "K"
            )
        ]
    }

    private var informationRows:
        [DimensionlessNumberInformationRow] {

        guard let result else {
            return []
        }

        let direction: String

        switch result.buoyancyDirection {
        case .heatedSurface:
            direction = "Heated surface"

        case .cooledSurface:
            direction = "Cooled surface"

        case .noTemperatureDifference:
            direction = "No temperature difference"
        }

        return [
            .init(
                id: "direction",
                title: "Thermal Condition",
                value: direction
            )
        ]
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                input: GrashofNumberInput(
                    gravitationalAcceleration:
                        try InputValidator.parseNumber(
                            gravityInput,
                            fieldName:
                                "gravitational acceleration"
                        ),
                    thermalExpansionCoefficient:
                        try InputValidator.parseNumber(
                            expansionCoefficientInput,
                            fieldName:
                                "thermal expansion coefficient"
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
                    characteristicLength:
                        try InputValidator.parseNumber(
                            characteristicLengthInput,
                            fieldName:
                                "characteristic length"
                        ),
                    kinematicViscosity:
                        try InputValidator.parseNumber(
                            kinematicViscosityInput,
                            fieldName:
                                "kinematic viscosity"
                        )
                )
            )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        gravityInput = "9.80665"
        expansionCoefficientInput = "0.0033"
        surfaceTemperatureInput = "100"
        fluidTemperatureInput = "20"
        characteristicLengthInput = "0.5"
        kinematicViscosityInput = "0.000015"
        clearResult()
    }

    private func resetInputs() {
        gravityInput = ""
        expansionCoefficientInput = ""
        surfaceTemperatureInput = ""
        fluidTemperatureInput = ""
        characteristicLengthInput = ""
        kinematicViscosityInput = ""
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
        GrashofNumberView()
    }
}
