import SwiftUI

struct BoilingHeatTransferView: View {

    @State private var surfaceTemperatureInput = "120"
    @State private var saturationTemperatureInput = "100"
    @State private var coefficientInput = "5000"
    @State private var areaInput = "2"

    @State
    private var result:
        BoilingHeatTransferResult?

    @State
    private var errorMessage = ""

    private let engine =
        BoilingHeatTransferEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        HeatTransferCalculatorView(
            symbolName:
                "bubbles.and.sparkles.fill",
            title: "Boiling Heat Transfer",
            subtitle:
                "Estimate boiling duty from wall superheat and coefficient",
            formulaTitle:
                "Boiling Heat-Flux Model",
            formula:
                "q″ = hᵦ(Tₛ − Tₛₐₜ)",
            explanation:
                "A coefficient-based engineering estimate. Correlation selection and critical heat flux checks remain outside this simplified model.",
            sectionTitle:
                "Surface and Saturation Conditions",
            fields: [
                .init(
                    id: "surface",
                    title: "Surface Temperature",
                    symbol: "Tₛ",
                    unit: "°C",
                    placeholder: "Example: 120",
                    text:
                        $surfaceTemperatureInput
                ),
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
                    id: "h",
                    title:
                        "Boiling Heat-Transfer Coefficient",
                    symbol: "hᵦ",
                    unit: "W/(m²·K)",
                    placeholder: "Example: 5000",
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
                "Calculate Boiling Duty",
            calculateSystemImage:
                "bubbles.and.sparkles.fill",
            resultItems: resultItems,
            interpretationTitle:
                "Boiling Assessment",
            interpretationSystemImage:
                "thermometer.high",
            informationRows: informationRows,
            interpretationText:
                "Positive wall superheat is required for this simplified boiling estimate.",
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
                label: "Wall Superheat",
                value:
                    formatter.format(
                        result.wallSuperheat
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
                input: BoilingHeatTransferInput(
                    surfaceTemperature:
                        try InputValidator.parseNumber(
                            surfaceTemperatureInput,
                            fieldName:
                                "surface temperature"
                        ),
                    saturationTemperature:
                        try InputValidator.parseNumber(
                            saturationTemperatureInput,
                            fieldName:
                                "saturation temperature"
                        ),
                    boilingHeatTransferCoefficient:
                        try InputValidator.parseNumber(
                            coefficientInput,
                            fieldName:
                                "boiling heat-transfer coefficient"
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
        surfaceTemperatureInput = "120"
        saturationTemperatureInput = "100"
        coefficientInput = "5000"
        areaInput = "2"
        result = nil
        errorMessage = ""
    }

    private func clear() {
        surfaceTemperatureInput = ""
        saturationTemperatureInput = ""
        coefficientInput = ""
        areaInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BoilingHeatTransferView()
    }
}
