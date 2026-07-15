import Foundation

struct LumpedCapacitanceEngine {

    func calculate(
        input: LumpedCapacitanceInput
    ) throws -> LumpedCapacitanceResult {

        try validate(input)

        let thermalCapacity =
            input.mass
            * input.specificHeatCapacity

        let convectionConductance =
            input.heatTransferCoefficient
            * input.surfaceArea

        let timeConstant =
            thermalCapacity
            / convectionConductance

        let dimensionlessTemperatureRatio =
            exp(
                -input.elapsedTime
                / timeConstant
            )

        let temperatureAtTime =
            input.ambientTemperature
            + (
                input.initialTemperature
                - input.ambientTemperature
            )
            * dimensionlessTemperatureRatio

        let biotNumber =
            input.heatTransferCoefficient
            * input.characteristicLength
            / input.thermalConductivity

        let energyReleasedByBody =
            thermalCapacity
            * (
                input.initialTemperature
                - temperatureAtTime
            )

        return LumpedCapacitanceResult(
            temperatureAtTime:
                temperatureAtTime,
            dimensionlessTemperatureRatio:
                dimensionlessTemperatureRatio,
            timeConstant:
                timeConstant,
            biotNumber:
                biotNumber,
            lumpedCriterionSatisfied:
                biotNumber < 0.1,
            energyReleasedByBody:
                energyReleasedByBody,
            process:
                process(
                    initialTemperature:
                        input.initialTemperature,
                    ambientTemperature:
                        input.ambientTemperature
                )
        )
    }

    private func process(
        initialTemperature: Double,
        ambientTemperature: Double
    ) -> LumpedCapacitanceProcess {

        if initialTemperature > ambientTemperature {
            return .cooling
        }

        if initialTemperature < ambientTemperature {
            return .heating
        }

        return .equilibrium
    }

    private func validate(
        _ input: LumpedCapacitanceInput
    ) throws {

        let values = [
            input.mass,
            input.specificHeatCapacity,
            input.heatTransferCoefficient,
            input.surfaceArea,
            input.initialTemperature,
            input.ambientTemperature,
            input.elapsedTime,
            input.thermalConductivity,
            input.characteristicLength
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LumpedCapacitanceError
                .nonFiniteInput
        }

        guard input.mass > 0 else {
            throw LumpedCapacitanceError
                .nonPositiveMass
        }

        guard input.specificHeatCapacity > 0 else {
            throw LumpedCapacitanceError
                .nonPositiveSpecificHeatCapacity
        }

        guard input.heatTransferCoefficient > 0 else {
            throw LumpedCapacitanceError
                .nonPositiveHeatTransferCoefficient
        }

        guard input.surfaceArea > 0 else {
            throw LumpedCapacitanceError
                .nonPositiveSurfaceArea
        }

        guard input.elapsedTime >= 0 else {
            throw LumpedCapacitanceError
                .negativeElapsedTime
        }

        guard input.thermalConductivity > 0 else {
            throw LumpedCapacitanceError
                .nonPositiveThermalConductivity
        }

        guard input.characteristicLength > 0 else {
            throw LumpedCapacitanceError
                .nonPositiveCharacteristicLength
        }
    }
}
