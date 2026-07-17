struct IsobaricIdealGasProcessEngine:
    Sendable {

    func calculate(
        _ input:
            IsobaricIdealGasProcessInput
    ) throws
        -> IsobaricIdealGasProcessResult {

        let values = [
            input.mass,
            input.specificHeatAtConstantPressure,
            input.specificGasConstant,
            input.initialTemperatureKelvin,
            input.finalTemperatureKelvin
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IsobaricIdealGasProcessError
                .nonFiniteInput
        }

        guard input.mass >= 0 else {
            throw IsobaricIdealGasProcessError
                .negativeMass
        }

        guard
            input.specificHeatAtConstantPressure > 0,
            input.specificGasConstant > 0
        else {
            throw IsobaricIdealGasProcessError
                .nonPositiveProperty
        }

        guard
            input.specificHeatAtConstantPressure
            > input.specificGasConstant
        else {
            throw IsobaricIdealGasProcessError
                .invalidHeatCapacityRelation
        }

        guard
            input.initialTemperatureKelvin > 0,
            input.finalTemperatureKelvin > 0
        else {
            throw IsobaricIdealGasProcessError
                .nonPositiveTemperature
        }

        let deltaT =
            input.finalTemperatureKelvin
            - input.initialTemperatureKelvin

        let heat =
            input.mass
            * input.specificHeatAtConstantPressure
            * deltaT

        let work =
            input.mass
            * input.specificGasConstant
            * deltaT

        let internalEnergy =
            heat - work

        let volumeRatio =
            input.finalTemperatureKelvin
            / input.initialTemperatureKelvin

        let direction: String

        if deltaT > 0 {
            direction = "Constant-pressure heating"
        } else if deltaT < 0 {
            direction = "Constant-pressure cooling"
        } else {
            direction = "No temperature change"
        }

        let outputs = [
            deltaT,
            heat,
            work,
            internalEnergy,
            volumeRatio
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw IsobaricIdealGasProcessError
                .numericalFailure
        }

        return .init(
            temperatureChange:
                deltaT,
            heatToSystem:
                heat,
            workBySystem:
                work,
            internalEnergyChange:
                internalEnergy,
            volumeRatio:
                volumeRatio,
            processDirection:
                direction,
            modelName:
                "Constant-pressure ideal-gas process",
            limitationDescription:
                "Uses constant Cp and R. Positive heat and work correspond to heating and expansion."
        )
    }
}
