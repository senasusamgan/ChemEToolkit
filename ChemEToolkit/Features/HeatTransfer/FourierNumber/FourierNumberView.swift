import SwiftUI

struct FourierNumberView: View {

    @State
    private var thermalDiffusivityInput = "0.00001"

    @State
    private var elapsedTimeInput = "3600"

    @State
    private var characteristicLengthInput = "0.1"

    @State
    private var result: FourierNumberResult?

    @State
    private var errorMessage = ""

    private let engine = FourierNumberEngine()
    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        DimensionlessNumberCalculatorView(
            symbolName:
                "clock.arrow.circlepath",
            title: "Fourier Number",
            subtitle:
                "Compare elapsed time with the thermal-diffusion time scale",
            formulaTitle: "Fourier Number",
            formula: "Fo = αt / L𝚌²",
            explanation:
                "A dimensionless time used in transient heat-conduction solutions.",
            fields: [
                .init(
                    id: "alpha",
                    title: "Thermal Diffusivity",
                    symbol: "α",
                    unit: "m²/s",
                    placeholder: "Example: 0.00001",
                    text: $thermalDiffusivityInput
                ),
                .init(
                    id: "time",
                    title: "Elapsed Time",
                    symbol: "t",
                    unit: "s",
                    placeholder: "Example: 3600",
                    text: $elapsedTimeInput
                ),
                .init(
                    id: "length",
                    title: "Characteristic Length",
                    symbol: "L𝚌",
                    unit: "m",
                    placeholder: "Example: 0.1",
                    text: $characteristicLengthInput
                )
            ],
            calculateTitle:
                "Calculate Fourier Number",
            calculateSystemImage:
                "clock.arrow.circlepath",
            resultItems: resultItems,
            interpretationTitle:
                "Diffusion-Length Interpretation",
            interpretationSystemImage:
                "ruler.fill",
            informationRows: informationRows,
            interpretationText:
                "The normalized diffusion length equals √Fo.",
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
                label: "Fourier Number",
                value:
                    formatter.format(
                        result.fourierNumber
                    ),
                unit: "—"
            ),
            CalculationResultDisplayItem(
                label:
                    "Thermal Diffusion Length",
                value:
                    formatter.format(
                        result
                            .thermalDiffusionLength
                    ),
                unit: "m"
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
                id: "normalized",
                title:
                    "Normalized Diffusion Length",
                value:
                    formatter.format(
                        result
                            .normalizedDiffusionLength
                    )
            )
        ]
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                input: FourierNumberInput(
                    thermalDiffusivity:
                        try InputValidator.parseNumber(
                            thermalDiffusivityInput,
                            fieldName:
                                "thermal diffusivity"
                        ),
                    elapsedTime:
                        try InputValidator.parseNumber(
                            elapsedTimeInput,
                            fieldName:
                                "elapsed time"
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
        thermalDiffusivityInput = "0.00001"
        elapsedTimeInput = "3600"
        characteristicLengthInput = "0.1"
        clearResult()
    }

    private func resetInputs() {
        thermalDiffusivityInput = ""
        elapsedTimeInput = ""
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
        FourierNumberView()
    }
}
