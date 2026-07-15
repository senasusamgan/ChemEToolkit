import SwiftUI

struct NusseltNumberView: View {

    @State
    private var heatTransferCoefficientInput = "100"

    @State
    private var characteristicLengthInput = "0.05"

    @State
    private var thermalConductivityInput = "0.6"

    @State
    private var result: NusseltNumberResult?

    @State
    private var errorMessage = ""

    private let engine = NusseltNumberEngine()
    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        DimensionlessNumberCalculatorView(
            symbolName:
                "arrow.up.and.down.and.arrow.left.and.right",
            title: "Nusselt Number",
            subtitle:
                "Compare convection with conduction across a fluid layer",
            formulaTitle: "Nusselt Number",
            formula: "Nu = hL𝚌 / k",
            explanation:
                "Relates convective heat transfer to conduction across a characteristic fluid length.",
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
                    placeholder: "Example: 0.05",
                    text: $characteristicLengthInput
                ),
                .init(
                    id: "k",
                    title: "Fluid Thermal Conductivity",
                    symbol: "k",
                    unit: "W/(m·K)",
                    placeholder: "Example: 0.6",
                    text: $thermalConductivityInput
                )
            ],
            calculateTitle:
                "Calculate Nusselt Number",
            calculateSystemImage:
                "arrow.up.and.down.and.arrow.left.and.right",
            resultItems: resultItems,
            interpretationTitle:
                "Heat-Transfer Interpretation",
            interpretationSystemImage:
                "flame.fill",
            informationRows: informationRows,
            interpretationText:
                result?.transportRegime.description
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
                label: "Nusselt Number",
                value:
                    formatter.format(
                        result.nusseltNumber
                    ),
                unit: "—"
            ),
            CalculationResultDisplayItem(
                label:
                    "Reference Conduction Coefficient",
                value:
                    formatter.format(
                        result
                            .referenceConductionCoefficient
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

        let regime: String

        switch result.transportRegime {
        case .belowUnity:
            regime = "Below unity"

        case .approximatelyUnity:
            regime = "Approximately unity"

        case .convectionEnhanced:
            regime = "Convection enhanced"
        }

        return [
            .init(
                id: "regime",
                title: "Transport Regime",
                value: regime
            )
        ]
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                input: NusseltNumberInput(
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
                    fluidThermalConductivity:
                        try InputValidator.parseNumber(
                            thermalConductivityInput,
                            fieldName:
                                "fluid thermal conductivity"
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
        characteristicLengthInput = "0.05"
        thermalConductivityInput = "0.6"
        clearResult()
    }

    private func resetInputs() {
        heatTransferCoefficientInput = ""
        characteristicLengthInput = ""
        thermalConductivityInput = ""
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
        NusseltNumberView()
    }
}
