import SwiftUI

struct SphericalWallConductionView: View {

    @State
    private var thermalConductivityInput = "15"

    @State
    private var innerRadiusInput = "0.05"

    @State
    private var outerRadiusInput = "0.1"

    @State
    private var innerTemperatureInput = "200"

    @State
    private var outerTemperatureInput = "50"

    @State
    private var result:
        SphericalWallConductionResult?

    @State
    private var errorMessage = ""

    private let engine =
        SphericalWallConductionEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        HeatTransferCalculatorView(
            symbolName: "circle.circle.fill",
            title: "Spherical Wall Conduction",
            subtitle:
                "Calculate radial conduction through a spherical shell",
            formulaTitle:
                "Spherical Thermal Resistance",
            formula:
                "R = [1/rᵢ − 1/rₒ] / (4πk)",
            explanation:
                "Uses the steady-state one-dimensional radial-conduction model with constant thermal conductivity.",
            sectionTitle:
                "Material, Geometry and Temperatures",
            fields: [
                .init(
                    id: "k",
                    title: "Thermal Conductivity",
                    symbol: "k",
                    unit: "W/(m·K)",
                    placeholder: "Example: 15",
                    text:
                        $thermalConductivityInput
                ),
                .init(
                    id: "ri",
                    title: "Inner Radius",
                    symbol: "rᵢ",
                    unit: "m",
                    placeholder: "Example: 0.05",
                    text: $innerRadiusInput
                ),
                .init(
                    id: "ro",
                    title: "Outer Radius",
                    symbol: "rₒ",
                    unit: "m",
                    placeholder: "Example: 0.1",
                    text: $outerRadiusInput
                ),
                .init(
                    id: "ti",
                    title:
                        "Inner-Surface Temperature",
                    symbol: "Tᵢ",
                    unit: "°C",
                    placeholder: "Example: 200",
                    text: $innerTemperatureInput
                ),
                .init(
                    id: "to",
                    title:
                        "Outer-Surface Temperature",
                    symbol: "Tₒ",
                    unit: "°C",
                    placeholder: "Example: 50",
                    text: $outerTemperatureInput
                )
            ],
            calculateTitle:
                "Calculate Spherical Conduction",
            calculateSystemImage:
                "circle.circle.fill",
            resultItems: resultItems,
            interpretationTitle:
                "Surface Summary",
            interpretationSystemImage:
                "circle.grid.cross.fill",
            informationRows: informationRows,
            interpretationText:
                "The same heat rate crosses every concentric surface, while heat flux decreases as radius increases.",
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
                label: "Heat Transfer Rate",
                value:
                    formatter.format(
                        result.heatTransferRate
                    ),
                unit: "W"
            ),
            CalculationResultDisplayItem(
                label: "Thermal Resistance",
                value:
                    formatter.format(
                        result.thermalResistance
                    ),
                unit: "K/W"
            ),
            CalculationResultDisplayItem(
                label: "Inner Heat Flux",
                value:
                    formatter.format(
                        result.innerSurfaceHeatFlux
                    ),
                unit: "W/m²"
            ),
            CalculationResultDisplayItem(
                label: "Outer Heat Flux",
                value:
                    formatter.format(
                        result.outerSurfaceHeatFlux
                    ),
                unit: "W/m²"
            )
        ]
    }

    private var informationRows:
        [HeatTransferInformationRow] {

        guard let result else {
            return []
        }

        return [
            .init(
                id: "deltaT",
                title: "Temperature Difference",
                value:
                    "\(formatter.format(result.temperatureDifference)) K"
            ),
            .init(
                id: "innerArea",
                title: "Inner Surface Area",
                value:
                    "\(formatter.format(result.innerSurfaceArea)) m²"
            ),
            .init(
                id: "outerArea",
                title: "Outer Surface Area",
                value:
                    "\(formatter.format(result.outerSurfaceArea)) m²"
            )
        ]
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                input:
                    SphericalWallConductionInput(
                        thermalConductivity:
                            try InputValidator.parseNumber(
                                thermalConductivityInput,
                                fieldName:
                                    "thermal conductivity"
                            ),
                        innerRadius:
                            try InputValidator.parseNumber(
                                innerRadiusInput,
                                fieldName:
                                    "inner radius"
                            ),
                        outerRadius:
                            try InputValidator.parseNumber(
                                outerRadiusInput,
                                fieldName:
                                    "outer radius"
                            ),
                        innerSurfaceTemperature:
                            try InputValidator.parseNumber(
                                innerTemperatureInput,
                                fieldName:
                                    "inner-surface temperature"
                            ),
                        outerSurfaceTemperature:
                            try InputValidator.parseNumber(
                                outerTemperatureInput,
                                fieldName:
                                    "outer-surface temperature"
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
        thermalConductivityInput = "15"
        innerRadiusInput = "0.05"
        outerRadiusInput = "0.1"
        innerTemperatureInput = "200"
        outerTemperatureInput = "50"
        clearResult()
    }

    private func resetInputs() {
        thermalConductivityInput = ""
        innerRadiusInput = ""
        outerRadiusInput = ""
        innerTemperatureInput = ""
        outerTemperatureInput = ""
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
        SphericalWallConductionView()
    }
}
