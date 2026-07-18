import Foundation

struct CombinedDryerTimeEngine:
    Sendable {

    func calculate(
        _ input:
            CombinedDryerTimeInput
    ) throws
        -> CombinedDryerTimeResult {

        let values = [
            input.drySolidMass,
            input.dryingArea,
            input.initialMoistureDryBasis,
            input.criticalMoistureDryBasis,
            input.finalMoistureDryBasis,
            input.equilibriumMoistureDryBasis,
            input.constantDryingFlux
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CombinedDryerTimeError
                .nonFiniteInput
        }

        guard
            input.drySolidMass > 0,
            input.dryingArea > 0,
            input.constantDryingFlux > 0
        else {
            throw CombinedDryerTimeError
                .nonPositiveMassAreaOrFlux
        }

        guard
            input.initialMoistureDryBasis
                > input.criticalMoistureDryBasis,
            input.criticalMoistureDryBasis
                > input.finalMoistureDryBasis,
            input.finalMoistureDryBasis
                > input.equilibriumMoistureDryBasis,
            input.equilibriumMoistureDryBasis >= 0
        else {
            throw CombinedDryerTimeError
                .invalidMoistureOrdering
        }

        let capacity =
            input.dryingArea
            * input.constantDryingFlux

        let constantMoisture =
            input.drySolidMass
            * (
                input.initialMoistureDryBasis
                - input.criticalMoistureDryBasis
            )

        let constantTime =
            constantMoisture
            / capacity

        let criticalFreeMoisture =
            input.criticalMoistureDryBasis
            - input.equilibriumMoistureDryBasis

        let finalFreeMoisture =
            input.finalMoistureDryBasis
            - input.equilibriumMoistureDryBasis

        let fallingTime =
            input.drySolidMass
            * criticalFreeMoisture
            / capacity
            * Foundation.log(
                criticalFreeMoisture
                / finalFreeMoisture
            )

        let fallingMoisture =
            input.drySolidMass
            * (
                input.criticalMoistureDryBasis
                - input.finalMoistureDryBasis
            )

        let totalTime =
            constantTime
            + fallingTime

        let totalMoisture =
            constantMoisture
            + fallingMoisture

        let outputs = [
            constantTime,
            fallingTime,
            totalTime,
            constantMoisture,
            fallingMoisture,
            totalMoisture
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            totalTime > 0
        else {
            throw CombinedDryerTimeError
                .numericalFailure
        }

        return .init(
            constantRateTime:
                constantTime,
            fallingRateTime:
                fallingTime,
            totalDryingTime:
                totalTime,
            totalMoistureRemoved:
                totalMoisture,
            constantRateMoistureRemoved:
                constantMoisture,
            fallingRateMoistureRemoved:
                fallingMoisture,
            modelName:
                "Combined constant-rate and linear falling-rate dryer",
            limitationDescription:
                "Assumes a constant exposed area and a linear falling-rate curve between critical and equilibrium moisture."
        )
    }
}
