import SwiftUI

struct RayleighNumberView: View {

    @State
    private var grashofNumberInput =
        "100000000"

    @State
    private var prandtlNumberInput = "0.7"

    @State
    private var result: RayleighNumberResult?

    @State
    private var errorMessage = ""

    private let engine = RayleighNumberEngine()
    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        DimensionlessNumberCalculatorView(
            symbolName: "wind.circle.fill",
            title: "Rayleigh Number",
            subtitle:
                "Combine Grashof and Prandtl numbers for natural convection",
            formulaTitle: "Rayleigh Number",
            formula: "Ra = Gr × Pr",
            explanation:
                "A principal parameter used in natural-convection correlations.",
            fields: [
                .init(
                    id: "gr",
                    title: "Grashof Number",
                    symbol: "Gr",
                    unit: "—",
                    placeholder: "Example: 100000000",
                    text: $grashofNumberInput
                ),
                .init(
                    id: "pr",
                    title: "Prandtl Number",
                    symbol: "Pr",
                    unit: "—",
                    placeholder: "Example: 0.7",
                    text: $prandtlNumberInput
                )
            ],
            calculateTitle:
                "Calculate Rayleigh Number",
            calculateSystemImage:
                "wind.circle.fill",
            resultItems: resultItems,
            interpretationTitle:
                "Natural-Convection Inputs",
            interpretationSystemImage:
                "wind",
            informationRows: informationRows,
            interpretationText:
                "Applicable correlation ranges depend on geometry and boundary conditions.",
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
                label: "Rayleigh Number",
                value:
                    formatter.format(
                        result.rayleighNumber
                    ),
                unit: "—"
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
                id: "gr",
                title: "Grashof Number",
                value:
                    formatter.format(
                        result.grashofNumber
                    )
            ),
            .init(
                id: "pr",
                title: "Prandtl Number",
                value:
                    formatter.format(
                        result.prandtlNumber
                    )
            )
        ]
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                input: RayleighNumberInput(
                    grashofNumber:
                        try InputValidator.parseNumber(
                            grashofNumberInput,
                            fieldName:
                                "Grashof number"
                        ),
                    prandtlNumber:
                        try InputValidator.parseNumber(
                            prandtlNumberInput,
                            fieldName:
                                "Prandtl number"
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
        grashofNumberInput = "100000000"
        prandtlNumberInput = "0.7"
        clearResult()
    }

    private func resetInputs() {
        grashofNumberInput = ""
        prandtlNumberInput = ""
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
        RayleighNumberView()
    }
}
