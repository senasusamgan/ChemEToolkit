import SwiftUI

struct LumpedCapacitanceView: View {

    @State private var massInput = "2"
    @State private var specificHeatInput = "500"

    @State
    private var heatTransferCoefficientInput = "100"

    @State private var surfaceAreaInput = "1"

    @State
    private var initialTemperatureInput = "100"

    @State
    private var ambientTemperatureInput = "20"

    @State private var elapsedTimeInput = "10"

    @State
    private var thermalConductivityInput = "50"

    @State
    private var characteristicLengthInput = "0.01"

    @State
    private var result:
        LumpedCapacitanceResult?

    @State
    private var errorMessage = ""

    private let engine =
        LumpedCapacitanceEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        HeatTransferCalculatorView(
            symbolName:
                "thermometer.medium.slash",
            title:
                "Transient Lumped-Capacitance Method",
            subtitle:
                "Predict uniform object temperature during transient heating or cooling",
            formulaTitle:
                "Lumped Temperature Response",
            formula:
                "(T − T∞)/(Tᵢ − T∞) = exp[−hAt/(mcₚ)]",
            explanation:
                "Assumes negligible internal temperature gradients; the common applicability check is Bi < 0.1.",
            sectionTitle:
                "Object, Convection and Time",
            fields: fields,
            calculateTitle:
                "Calculate Transient Temperature",
            calculateSystemImage:
                "thermometer.medium.slash",
            resultItems: resultItems,
            interpretationTitle:
                "Lumped-Method Assessment",
            interpretationSystemImage:
                "clock.arrow.circlepath",
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
                id: "mass",
                title: "Object Mass",
                symbol: "m",
                unit: "kg",
                placeholder: "Example: 2",
                text: $massInput
            ),
            .init(
                id: "cp",
                title: "Specific Heat Capacity",
                symbol: "cₚ",
                unit: "J/(kg·K)",
                placeholder: "Example: 500",
                text: $specificHeatInput
            ),
            .init(
                id: "h",
                title:
                    "Heat-Transfer Coefficient",
                symbol: "h",
                unit: "W/(m²·K)",
                placeholder: "Example: 100",
                text:
                    $heatTransferCoefficientInput
            ),
            .init(
                id: "area",
                title: "Surface Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 1",
                text: $surfaceAreaInput
            ),
            .init(
                id: "initial",
                title: "Initial Temperature",
                symbol: "Tᵢ",
                unit: "°C",
                placeholder: "Example: 100",
                text: $initialTemperatureInput
            ),
            .init(
                id: "ambient",
                title: "Ambient Temperature",
                symbol: "T∞",
                unit: "°C",
                placeholder: "Example: 20",
                text: $ambientTemperatureInput
            ),
            .init(
                id: "time",
                title: "Elapsed Time",
                symbol: "t",
                unit: "s",
                placeholder: "Example: 10",
                text: $elapsedTimeInput
            ),
            .init(
                id: "k",
                title:
                    "Object Thermal Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 50",
                text: $thermalConductivityInput
            ),
            .init(
                id: "length",
                title: "Characteristic Length",
                symbol: "L𝚌",
                unit: "m",
                placeholder: "Example: 0.01",
                text: $characteristicLengthInput
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
                label:
                    "Temperature at Time",
                value:
                    formatter.format(
                        result.temperatureAtTime
                    ),
                unit: "°C"
            ),
            CalculationResultDisplayItem(
                label: "Time Constant",
                value:
                    formatter.format(
                        result.timeConstant
                    ),
                unit: "s"
            ),
            CalculationResultDisplayItem(
                label: "Biot Number",
                value:
                    formatter.format(
                        result.biotNumber
                    ),
                unit: "—"
            ),
            CalculationResultDisplayItem(
                label:
                    "Energy Released by Body",
                value:
                    formatter.format(
                        result
                            .energyReleasedByBody
                    ),
                unit: "J"
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
                id: "ratio",
                title:
                    "Dimensionless Temperature",
                value:
                    formatter.format(
                        result
                            .dimensionlessTemperatureRatio
                    )
            ),
            .init(
                id: "process",
                title: "Process",
                value:
                    processTitle(
                        result.process
                    )
            ),
            .init(
                id: "criterion",
                title: "Bi < 0.1",
                value:
                    result
                        .lumpedCriterionSatisfied
                    ? "Satisfied"
                    : "Not satisfied"
            )
        ]
    }

    private var interpretationText: String {
        guard let result else {
            return ""
        }

        let criterionText =
            result.lumpedCriterionSatisfied
            ? "The lumped-capacitance approximation is usually acceptable."
            : "The lumped-capacitance approximation may be inaccurate because internal gradients may be significant."

        return "\(result.process.description) \(criterionText)"
    }

    private func processTitle(
        _ process:
            LumpedCapacitanceProcess
    ) -> String {

        switch process {
        case .cooling:
            return "Cooling"

        case .heating:
            return "Heating"

        case .equilibrium:
            return "Equilibrium"
        }
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                input: LumpedCapacitanceInput(
                    mass:
                        try InputValidator.parseNumber(
                            massInput,
                            fieldName: "object mass"
                        ),
                    specificHeatCapacity:
                        try InputValidator.parseNumber(
                            specificHeatInput,
                            fieldName:
                                "specific heat capacity"
                        ),
                    heatTransferCoefficient:
                        try InputValidator.parseNumber(
                            heatTransferCoefficientInput,
                            fieldName:
                                "heat-transfer coefficient"
                        ),
                    surfaceArea:
                        try InputValidator.parseNumber(
                            surfaceAreaInput,
                            fieldName: "surface area"
                        ),
                    initialTemperature:
                        try InputValidator.parseNumber(
                            initialTemperatureInput,
                            fieldName:
                                "initial temperature"
                        ),
                    ambientTemperature:
                        try InputValidator.parseNumber(
                            ambientTemperatureInput,
                            fieldName:
                                "ambient temperature"
                        ),
                    elapsedTime:
                        try InputValidator.parseNumber(
                            elapsedTimeInput,
                            fieldName:
                                "elapsed time"
                        ),
                    thermalConductivity:
                        try InputValidator.parseNumber(
                            thermalConductivityInput,
                            fieldName:
                                "object thermal conductivity"
                        ),
                    characteristicLength:
                        try InputValidator.parseNumber(
                            characteristicLengthInput,
                            fieldName:
                                "characteristic length"
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
        massInput = "2"
        specificHeatInput = "500"
        heatTransferCoefficientInput = "100"
        surfaceAreaInput = "1"
        initialTemperatureInput = "100"
        ambientTemperatureInput = "20"
        elapsedTimeInput = "10"
        thermalConductivityInput = "50"
        characteristicLengthInput = "0.01"
        clearResult()
    }

    private func resetInputs() {
        massInput = ""
        specificHeatInput = ""
        heatTransferCoefficientInput = ""
        surfaceAreaInput = ""
        initialTemperatureInput = ""
        ambientTemperatureInput = ""
        elapsedTimeInput = ""
        thermalConductivityInput = ""
        characteristicLengthInput = ""
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
        LumpedCapacitanceView()
    }
}
