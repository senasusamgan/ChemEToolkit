struct InternalEnergyChangeCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            InternalEnergyChangeCalculatorInput
    ) throws
        -> InternalEnergyChangeCalculatorResult {

        let values = [
            input.mass,
            input.specificHeatAtConstantVolume,
            input.initialTemperature,
            input.finalTemperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw InternalEnergyChangeCalculatorError
                .nonFiniteInput
        }

        guard input.mass >= 0 else {
            throw InternalEnergyChangeCalculatorError
                .negativeMass
        }

        guard
            input.specificHeatAtConstantVolume > 0
        else {
            throw InternalEnergyChangeCalculatorError
                .nonPositiveHeatCapacity
        }

        let deltaT =
            input.finalTemperature
            - input.initialTemperature

        let specificDeltaU =
            input.specificHeatAtConstantVolume
            * deltaT

        let totalDeltaU =
            input.mass
            * specificDeltaU

        let direction: String

        if totalDeltaU > 0 {
            direction = "Internal energy increases"
        } else if totalDeltaU < 0 {
            direction = "Internal energy decreases"
        } else {
            direction = "No internal-energy change"
        }

        let outputs = [
            deltaT,
            specificDeltaU,
            totalDeltaU
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw InternalEnergyChangeCalculatorError
                .numericalFailure
        }

        return .init(
            temperatureChange:
                deltaT,
            specificInternalEnergyChange:
                specificDeltaU,
            totalInternalEnergyChange:
                totalDeltaU,
            directionDescription:
                direction,
            modelName:
                "Constant-Cv internal-energy change",
            limitationDescription:
                "Uses ΔU = mCvΔT with constant Cv and no phase change, reaction or nonideal residual-energy correction."
        )
    }
}
