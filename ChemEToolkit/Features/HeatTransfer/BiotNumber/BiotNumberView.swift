import SwiftUI

struct BiotNumberView: View {

    @State
    private var heatTransferCoefficientInput = "100"

    @State
    private var characteristicLengthInput = "0.01"

    @State
    private var solidThermalConductivityInput = "50"

    @State
    private var result: BiotNumberResult?

    @State
    private var errorMessage = ""

    private let engine = BiotNumberEngine()
    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        DimensionlessNumberCalculatorView(
            symbolName: "cube.transparent.fill",
            title: "Biot Number",
            subtitle:
                "Compare internal conduction and surface convection resistance",
            formulaTitle: "Biot Number",
            formula: "Bi = hL𝚌 / kₛ",
            explanation:
                "A transient-conduction criterion comparing internal and external thermal resistance scales.",
            fields: [
                .init(
                    id: "h",
                    title: "Heat-Transfer Coefficient",
                    symbol: "h",
                    unit: "W/(m²·K)",
                    placeholder: "Example: 100",
                    text:
                        $heatTransferCoefficientInput
                ),
                .init(
                    id: "length",
                    title: "Characteristic Length",
                    symbol: "L𝚌",
                    unit: "m",
                    placeholder: "Example: 0.01",
                    text: $characteristicLengthInput
                ),
                .init(
                    id: "k",
                    title:
                        "Solid Thermal Conductivity",
                    symbol: "kₛ",
                    unit: "W/(m·K)",
                    placeholder: "Example: 50",
                    text:
                        $solidThermalConductivityInput
                )
            ],
            calculateTitle:
                "Calculate Biot Number",
            calculateSystemImage:
                "cube.transparent.fill",
            resultItems: resultItems,
            interpretationTitle:
                "Transient-Conduction Check",
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

    private var resultItems:
        [CalculationResultDisplayItem] {

        guard let result else {
            return []
        }

        return [
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
                    "Internal Conduction Scale",
                value:
                    formatter.format(
                        result
                            .internalConductionScale
                    ),
                unit: "W/(m²·K)"
            )
        ]
    }

    private var informationRows:
        [DimensionlessNumberInformationRow] {

        guard let result else {
            return []
        }

        return [
            .init(
                id: "criterion",
                title: "Bi < 0.1",
                value:
                    result
                        .lumpedCapacitanceUsuallyValid
                    ? "Satisfied"
                    : "Not satisfied"
            )
        ]
    }

    private var interpretationText: String {
        guard let result else {
            return ""
        }

        if result.lumpedCapacitanceUsuallyValid {
            return """
            The lumped-capacitance approximation is \
            usually acceptable under the common Bi < 0.1 \
            criterion.
            """
        }

        return """
        Significant internal temperature gradients may \
        occur; a spatial transient-conduction model may \
        be required.
        """
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                input: BiotNumberInput(
                    heatTransferCoefficient:
                        try InputValidator.parseNumber(
                            heatTransferCoefficientInput,
                            fieldName:
                                "heat-transfer coefficient"
                        ),
                    characteristicLength:
                        try InputValidator.parseNumber(
                            characteristicLengthInput,
                            fieldName:
                                "characteristic length"
                        ),
                    solidThermalConductivity:
                        try InputValidator.parseNumber(
                            solidThermalConductivityInput,
                            fieldName:
                                "solid thermal conductivity"
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
        heatTransferCoefficientInput = "100"
        characteristicLengthInput = "0.01"
        solidThermalConductivityInput = "50"
        clearResult()
    }

    private func resetInputs() {
        heatTransferCoefficientInput = ""
        characteristicLengthInput = ""
        solidThermalConductivityInput = ""
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
        BiotNumberView()
    }
}
