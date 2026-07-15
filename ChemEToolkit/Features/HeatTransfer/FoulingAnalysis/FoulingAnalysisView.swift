import SwiftUI

struct FoulingAnalysisView: View {

    @State
    private var hotCoefficientInput = "100"

    @State
    private var coldCoefficientInput = "50"

    @State
    private var wallConductivityInput = "10"

    @State
    private var wallThicknessInput = "0.02"

    @State
    private var hotFoulingInput = "0.001"

    @State
    private var coldFoulingInput = "0.002"

    @State
    private var areaInput = "10"

    @State
    private var hotTemperatureInput = "100"

    @State
    private var coldTemperatureInput = "20"

    @State
    private var result: FoulingAnalysisResult?

    @State
    private var errorMessage = ""

    private let engine =
        FoulingAnalysisEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        HeatTransferCalculatorView(
            symbolName:
                "exclamationmark.triangle.fill",
            title: "Fouling Analysis",
            subtitle:
                "Compare clean and fouled heat-transfer performance",
            formulaTitle:
                "Clean and Fouled Overall Coefficients",
            formula:
                "1/U𝒇 = 1/hₕ + R𝒇,ₕ + L/k + R𝒇,𝚌 + 1/h𝚌",
            explanation:
                "Quantifies how deposited layers increase thermal resistance and reduce heat-transfer duty.",
            sectionTitle:
                "Coefficients, Wall, Fouling and Duty",
            fields: fields,
            calculateTitle:
                "Analyze Fouling Performance",
            calculateSystemImage:
                "exclamationmark.triangle.fill",
            resultItems: resultItems,
            interpretationTitle:
                "Performance Comparison",
            interpretationSystemImage:
                "chart.bar.fill",
            informationRows: informationRows,
            interpretationText:
                interpretationText,
            errorMessage: errorMessage,
            loadExample: loadExample,
            clear: resetInputs,
            calculate: calculate
        )
    }

    private var fields:
        [HeatTransferInputFieldConfiguration] {

        [
            .init(
                id: "hh",
                title:
                    "Hot-Side Coefficient",
                symbol: "hₕ",
                unit: "W/(m²·K)",
                placeholder: "Example: 100",
                text: $hotCoefficientInput
            ),
            .init(
                id: "hc",
                title:
                    "Cold-Side Coefficient",
                symbol: "h𝚌",
                unit: "W/(m²·K)",
                placeholder: "Example: 50",
                text: $coldCoefficientInput
            ),
            .init(
                id: "k",
                title:
                    "Wall Thermal Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 10",
                text: $wallConductivityInput
            ),
            .init(
                id: "L",
                title: "Wall Thickness",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 0.02",
                text: $wallThicknessInput
            ),
            .init(
                id: "rfh",
                title:
                    "Hot-Side Fouling Resistance",
                symbol: "R𝒇,ₕ",
                unit: "m²·K/W",
                placeholder: "Example: 0.001",
                text: $hotFoulingInput
            ),
            .init(
                id: "rfc",
                title:
                    "Cold-Side Fouling Resistance",
                symbol: "R𝒇,𝚌",
                unit: "m²·K/W",
                placeholder: "Example: 0.002",
                text: $coldFoulingInput
            ),
            .init(
                id: "area",
                title: "Heat-Transfer Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 10",
                text: $areaInput
            ),
            .init(
                id: "hotT",
                title: "Hot-Side Temperature",
                symbol: "Tₕ",
                unit: "°C",
                placeholder: "Example: 100",
                text: $hotTemperatureInput
            ),
            .init(
                id: "coldT",
                title: "Cold-Side Temperature",
                symbol: "T𝚌",
                unit: "°C",
                placeholder: "Example: 20",
                text: $coldTemperatureInput
            )
        ]
    }

    private var resultItems:
        [CalculationResultDisplayItem] {

        guard let result else {
            return []
        }

        return [
            CalculationResultDisplayItem(
                label: "Clean Overall Coefficient",
                value:
                    formatter.format(
                        result
                            .cleanOverallCoefficient
                    ),
                unit: "W/(m²·K)"
            ),
            CalculationResultDisplayItem(
                label:
                    "Fouled Overall Coefficient",
                value:
                    formatter.format(
                        result
                            .fouledOverallCoefficient
                    ),
                unit: "W/(m²·K)"
            ),
            CalculationResultDisplayItem(
                label: "Clean Heat Transfer",
                value:
                    formatter.format(
                        result.cleanHeatTransferRate
                    ),
                unit: "W"
            ),
            CalculationResultDisplayItem(
                label: "Fouled Heat Transfer",
                value:
                    formatter.format(
                        result
                            .fouledHeatTransferRate
                    ),
                unit: "W"
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
                id: "cleanR",
                title: "Clean Resistance",
                value:
                    "\(formatter.format(result.cleanResistancePerUnitArea)) m²·K/W"
            ),
            .init(
                id: "fouledR",
                title: "Fouled Resistance",
                value:
                    "\(formatter.format(result.fouledResistancePerUnitArea)) m²·K/W"
            ),
            .init(
                id: "foulingR",
                title:
                    "Total Fouling Resistance",
                value:
                    "\(formatter.format(result.totalFoulingResistance)) m²·K/W"
            ),
            .init(
                id: "retention",
                title: "Coefficient Retention",
                value:
                    "\(formatter.format(result.coefficientRetentionRatio * 100))%"
            ),
            .init(
                id: "loss",
                title: "Performance Loss",
                value:
                    "\(formatter.format(result.performanceLossPercentage))%"
            )
        ]
    }

    private var interpretationText: String {
        guard let result else {
            return ""
        }

        if result.performanceLossPercentage == 0 {
            return "No fouling penalty is present for the entered resistances."
        }

        return """
        Fouling reduces both the overall coefficient and \
        heat-transfer duty by the same percentage when area \
        and temperature difference remain fixed.
        """
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                input: FoulingAnalysisInput(
                    hotSideHeatTransferCoefficient:
                        try InputValidator.parseNumber(
                            hotCoefficientInput,
                            fieldName:
                                "hot-side coefficient"
                        ),
                    coldSideHeatTransferCoefficient:
                        try InputValidator.parseNumber(
                            coldCoefficientInput,
                            fieldName:
                                "cold-side coefficient"
                        ),
                    wallThermalConductivity:
                        try InputValidator.parseNumber(
                            wallConductivityInput,
                            fieldName:
                                "wall thermal conductivity"
                        ),
                    wallThickness:
                        try InputValidator.parseNumber(
                            wallThicknessInput,
                            fieldName:
                                "wall thickness"
                        ),
                    hotSideFoulingResistance:
                        try InputValidator.parseNumber(
                            hotFoulingInput,
                            fieldName:
                                "hot-side fouling resistance"
                        ),
                    coldSideFoulingResistance:
                        try InputValidator.parseNumber(
                            coldFoulingInput,
                            fieldName:
                                "cold-side fouling resistance"
                        ),
                    heatTransferArea:
                        try InputValidator.parseNumber(
                            areaInput,
                            fieldName:
                                "heat-transfer area"
                        ),
                    hotSideTemperature:
                        try InputValidator.parseNumber(
                            hotTemperatureInput,
                            fieldName:
                                "hot-side temperature"
                        ),
                    coldSideTemperature:
                        try InputValidator.parseNumber(
                            coldTemperatureInput,
                            fieldName:
                                "cold-side temperature"
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
        hotCoefficientInput = "100"
        coldCoefficientInput = "50"
        wallConductivityInput = "10"
        wallThicknessInput = "0.02"
        hotFoulingInput = "0.001"
        coldFoulingInput = "0.002"
        areaInput = "10"
        hotTemperatureInput = "100"
        coldTemperatureInput = "20"
        clearResult()
    }

    private func resetInputs() {
        hotCoefficientInput = ""
        coldCoefficientInput = ""
        wallConductivityInput = ""
        wallThicknessInput = ""
        hotFoulingInput = ""
        coldFoulingInput = ""
        areaInput = ""
        hotTemperatureInput = ""
        coldTemperatureInput = ""
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
        FoulingAnalysisView()
    }
}
