struct EnthalpyChangeCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            EnthalpyChangeCalculatorInput
    ) throws
        -> EnthalpyChangeCalculatorResult {

        let values = [
            input.mass,
            input.specificHeatAtConstantPressure,
            input.initialTemperature,
            input.finalTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EnthalpyChangeCalculatorError
                .nonFiniteInput
        }

        guard input.mass >= 0 else {
            throw EnthalpyChangeCalculatorError
                .negativeMass
        }

        guard
            input.specificHeatAtConstantPressure > 0
        else {
            throw EnthalpyChangeCalculatorError
                .nonPositiveHeatCapacity
        }

        let deltaT =
            input.finalTemperature
            - input.initialTemperature

        let specificDeltaH =
            input.specificHeatAtConstantPressure
            * deltaT

        let totalDeltaH =
            input.mass
            * specificDeltaH

        let direction: String

        if totalDeltaH > 0 {
            direction = "Enthalpy increases"
        } else if totalDeltaH < 0 {
            direction = "Enthalpy decreases"
        } else {
            direction = "No enthalpy change"
        }

        let outputs = [
            deltaT,
            specificDeltaH,
            totalDeltaH
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw EnthalpyChangeCalculatorError
                .numericalFailure
        }

        return .init(
            temperatureChange:
                deltaT,
            specificEnthalpyChange:
                specificDeltaH,
            totalEnthalpyChange:
                totalDeltaH,
            directionDescription:
                direction,
            modelName:
                "Constant-Cp enthalpy change",
            limitationDescription:
                "Uses ΔH = mCpΔT with constant Cp and no phase change, reaction or pressure-dependent enthalpy correction."
        )
    }
}
