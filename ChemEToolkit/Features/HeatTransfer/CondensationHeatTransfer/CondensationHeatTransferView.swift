import SwiftUI

struct CondensationHeatTransferView: View {

    @State
    private var saturationTemperatureInput = "100"

    @State
    private var surfaceTemperatureInput = "80"

    @State
    private var coefficientInput = "8000"

    @State
    private var areaInput = "2"

    @State
    private var result:
        CondensationHeatTransferResult?

    @State
    private var errorMessage = ""

    private let engine =
        CondensationHeatTransferEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        HeatTransferCalculatorView(
            symbolName: "drop.fill",
            title:
                "Condensation Heat Transfer",
            subtitle:
                "Estimate condensation duty from temperature difference and coefficient",
            formulaTitle:
                "Condensation Heat-Flux Model",
            formula:
                "q″ = h𝚌(Tₛₐₜ − Tₛ)",
            explanation:
                "A coefficient-based engineering estimate for a wall colder than the saturated vapor.",
            sectionTitle:
                "Vapor and Surface Conditions",
            fields: [
                .init(
                    id: "sat",
                    title:
                        "Saturation Temperature",
                    symbol: "Tₛₐₜ",
                    unit: "°C",
                    placeholder: "Example: 100",
                    text:
                        $saturationTemperatureInput
                ),
                .init(
                    id: "surface",
                    title: "Surface Temperature",
                    symbol: "Tₛ",
                    unit: "°C",
                    placeholder: "Example: 80",
                    text:
                        $surfaceTemperatureInput
                ),
                .init(
                    id: "h",
                    title:
                        "Condensation Heat-Transfer Coefficient",
                    symbol: "h𝚌",
                    unit: "W/(m²·K)",
                    placeholder: "Example: 8000",
                    text: $coefficientInput
                ),
                .init(
                    id: "area",
                    title: "Surface Area",
                    symbol: "A",
                    unit: "m²",
                    placeholder: "Example: 2",
                    text: $areaInput
                )
            ],
            calculateTitle:
                "Calculate Condensation Duty",
            calculateSystemImage:
                "drop.fill",
            resultItems: resultItems,
            interpretationTitle:
                "Condensation Assessment",
            interpretationSystemImage:
                "drop.fill",
            informationRows: informationRows,
            interpretationText:
                "A positive saturation-to-wall temperature difference is required for this simplified condensation estimate.",
            errorMessage: errorMessage,
            loadExample: loadExample,
            clear: clear,
            calculate: calculate
        )
    }

    private var resultItems:
        [CalculationResultDisplayItem] {
        guard let result else { return [] }

        return [
            .init(
                label: "Temperature Difference",
                value:
                    formatter.format(
                        result.temperatureDifference
                    ),
                unit: "K"
            ),
            .init(
                label: "Heat Flux",
                value:
                    formatter.format(
                        result.heatFlux
                    ),
                unit: "W/m²"
            ),
            .init(
                label: "Heat Transfer Rate",
                value:
                    formatter.format(
                        result.heatTransferRate
                    ),
                unit: "W"
            )
        ]
    }

    private var informationRows:
        [HeatTransferInformationRow] {
        guard let result else { return [] }

        return [
            .init(
                id: "regime",
                title: "Indicator",
                value:
                    result.regimeIndicator.title
            )
        ]
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                input:
                    CondensationHeatTransferInput(
                        saturationTemperature:
                            try InputValidator.parseNumber(
                                saturationTemperatureInput,
                                fieldName:
                                    "saturation temperature"
                            ),
                        surfaceTemperature:
                            try InputValidator.parseNumber(
                                surfaceTemperatureInput,
                                fieldName:
                                    "surface temperature"
                            ),
                        condensationHeatTransferCoefficient:
                            try InputValidator.parseNumber(
                                coefficientInput,
                                fieldName:
                                    "condensation heat-transfer coefficient"
                            ),
                        surfaceArea:
                            try InputValidator.parseNumber(
                                areaInput,
                                fieldName:
                                    "surface area"
                            )
                    )
            )
        } catch let error as CalculationError {
            errorMessage =
                error.errorDescription
                ?? "Invalid input."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        saturationTemperatureInput = "100"
        surfaceTemperatureInput = "80"
        coefficientInput = "8000"
        areaInput = "2"
        result = nil
        errorMessage = ""
    }

    private func clear() {
        saturationTemperatureInput = ""
        surfaceTemperatureInput = ""
        coefficientInput = ""
        areaInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CondensationHeatTransferView()
    }
}
