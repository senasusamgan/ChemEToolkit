struct IsochoricIdealGasProcessEngine:
    Sendable {

    func calculate(
        _ input:
            IsochoricIdealGasProcessInput
    ) throws
        -> IsochoricIdealGasProcessResult {

        let values = [
            input.mass,
            input.specificHeatAtConstantVolume,
            input.initialTemperatureKelvin,
            input.finalTemperatureKelvin
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IsochoricIdealGasProcessError
                .nonFiniteInput
        }

        guard input.mass >= 0 else {
            throw IsochoricIdealGasProcessError
                .negativeMass
        }

        guard
            input.specificHeatAtConstantVolume > 0
        else {
            throw IsochoricIdealGasProcessError
                .nonPositiveHeatCapacity
        }

        guard
            input.initialTemperatureKelvin > 0,
            input.finalTemperatureKelvin > 0
        else {
            throw IsochoricIdealGasProcessError
                .nonPositiveTemperature
        }

        let deltaT =
            input.finalTemperatureKelvin
            - input.initialTemperatureKelvin

        let internalEnergy =
            input.mass
            * input.specificHeatAtConstantVolume
            * deltaT

        let pressureRatio =
            input.finalTemperatureKelvin
            / input.initialTemperatureKelvin

        let direction: String

        if deltaT > 0 {
            direction = "Rigid-vessel heating"
        } else if deltaT < 0 {
            direction = "Rigid-vessel cooling"
        } else {
            direction = "No temperature change"
        }

        let outputs = [
            deltaT,
            internalEnergy,
            pressureRatio
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw IsochoricIdealGasProcessError
                .numericalFailure
        }

        return .init(
            temperatureChange:
                deltaT,
            heatToSystem:
                internalEnergy,
            internalEnergyChange:
                internalEnergy,
            workBySystem:
                0,
            pressureRatio:
                pressureRatio,
            processDirection:
                direction,
            modelName:
                "Constant-volume ideal-gas process",
            limitationDescription:
                "Uses constant Cv. Boundary work is zero, so heat transfer equals the internal-energy change."
        )
    }
}
