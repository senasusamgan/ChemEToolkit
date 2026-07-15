import SwiftUI

struct PrandtlNumberView: View {

    @State
    private var dynamicViscosityInput = "0.001"

    @State
    private var specificHeatCapacityInput = "4180"

    @State
    private var thermalConductivityInput = "0.6"

    @State
    private var result: PrandtlNumberResult?

    @State
    private var errorMessage = ""

    private let engine = PrandtlNumberEngine()
    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        DimensionlessNumberCalculatorView(
            symbolName: "waveform.path.ecg",
            title: "Prandtl Number",
            subtitle:
                "Compare momentum and thermal diffusivity",
            formulaTitle: "Prandtl Number",
            formula: "Pr = μcₚ / k",
            explanation:
                "A fluid-property ratio used in momentum and heat-transfer correlations.",
            fields: [
                .init(
                    id: "mu",
                    title: "Dynamic Viscosity",
                    symbol: "μ",
                    unit: "Pa·s",
                    placeholder: "Example: 0.001",
                    text: $dynamicViscosityInput
                ),
                .init(
                    id: "cp",
                    title: "Specific Heat Capacity",
                    symbol: "cₚ",
                    unit: "J/(kg·K)",
                    placeholder: "Example: 4180",
                    text: $specificHeatCapacityInput
                ),
                .init(
                    id: "k",
                    title: "Thermal Conductivity",
                    symbol: "k",
                    unit: "W/(m·K)",
                    placeholder: "Example: 0.6",
                    text: $thermalConductivityInput
                )
            ],
            calculateTitle:
                "Calculate Prandtl Number",
            calculateSystemImage:
                "waveform.path.ecg",
            resultItems: resultItems,
            interpretationTitle:
                "Transport Interpretation",
            interpretationSystemImage:
                "arrow.left.arrow.right",
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
                label: "Prandtl Number",
                value:
                    formatter.format(
                        result.prandtlNumber
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

        let regime: String

        switch result.transportRegime {
        case .thermalDiffusionDominant:
            regime = "Thermal diffusion dominant"

        case .comparableDiffusion:
            regime = "Comparable diffusion"

        case .momentumDiffusionDominant:
            regime = "Momentum diffusion dominant"
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
                input: PrandtlNumberInput(
                    dynamicViscosity:
                        try InputValidator.parseNumber(
                            dynamicViscosityInput,
                            fieldName:
                                "dynamic viscosity"
                        ),
                    specificHeatCapacity:
                        try InputValidator.parseNumber(
                            specificHeatCapacityInput,
                            fieldName:
                                "specific heat capacity"
                        ),
                    thermalConductivity:
                        try InputValidator.parseNumber(
                            thermalConductivityInput,
                            fieldName:
                                "thermal conductivity"
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
        dynamicViscosityInput = "0.001"
        specificHeatCapacityInput = "4180"
        thermalConductivityInput = "0.6"
        clearResult()
    }

    private func resetInputs() {
        dynamicViscosityInput = ""
        specificHeatCapacityInput = ""
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
        PrandtlNumberView()
    }
}
