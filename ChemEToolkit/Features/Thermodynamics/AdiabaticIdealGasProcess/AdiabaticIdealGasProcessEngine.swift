import Foundation

struct AdiabaticIdealGasProcessEngine:
    Sendable {

    func calculate(
        _ input:
            AdiabaticIdealGasProcessInput
    ) throws
        -> AdiabaticIdealGasProcessResult {

        let values = [
            input.initialTemperatureKelvin,
            input.initialAbsolutePressure,
            input.finalAbsolutePressure,
            input.heatCapacityRatio,
            input.specificGasConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AdiabaticIdealGasProcessError
                .nonFiniteInput
        }

        guard input.initialTemperatureKelvin > 0 else {
            throw AdiabaticIdealGasProcessError
                .nonPositiveTemperature
        }

        guard
            input.initialAbsolutePressure > 0,
            input.finalAbsolutePressure > 0
        else {
            throw AdiabaticIdealGasProcessError
                .nonPositivePressure
        }

        guard input.heatCapacityRatio > 1 else {
            throw AdiabaticIdealGasProcessError
                .invalidHeatCapacityRatio
        }

        guard input.specificGasConstant > 0 else {
            throw AdiabaticIdealGasProcessError
                .nonPositiveGasConstant
        }

        let pressureRatio =
            input.finalAbsolutePressure
            / input.initialAbsolutePressure

        let exponent =
            (
                input.heatCapacityRatio - 1
            )
            / input.heatCapacityRatio

        let finalTemperature =
            input.initialTemperatureKelvin
            * Foundation.pow(
                pressureRatio,
                exponent
            )

        let volumeRatio =
            Foundation.pow(
                input.initialAbsolutePressure
                / input.finalAbsolutePressure,
                1 / input.heatCapacityRatio
            )

        let cv =
            input.specificGasConstant
            / (
                input.heatCapacityRatio - 1
            )

        let deltaU =
            cv
            * (
                finalTemperature
                - input.initialTemperatureKelvin
            )

        let work =
            -deltaU

        let direction: String

        if pressureRatio < 1 {
            direction = "Adiabatic expansion"
        } else if pressureRatio > 1 {
            direction = "Adiabatic compression"
        } else {
            direction = "No pressure change"
        }

        let outputs = [
            pressureRatio,
            exponent,
            finalTemperature,
            volumeRatio,
            cv,
            deltaU,
            work
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            finalTemperature > 0,
            volumeRatio > 0
        else {
            throw AdiabaticIdealGasProcessError
                .numericalFailure
        }

        return .init(
            finalTemperatureKelvin:
                finalTemperature,
            pressureRatio:
                pressureRatio,
            volumeRatio:
                volumeRatio,
            specificWorkBySystem:
                work,
            specificInternalEnergyChange:
                deltaU,
            processDirection:
                direction,
            modelName:
                "Reversible adiabatic ideal-gas relation",
            limitationDescription:
                "Assumes constant heat capacities, ideal-gas behavior and a reversible adiabatic path. Work is reported per unit mass."
        )
    }
}
