import Foundation

struct FixedBedAdsorberBreakthroughEngine:
    Sendable {

    func calculate(
        _ input:
            FixedBedAdsorberBreakthroughInput
    ) throws
        -> FixedBedAdsorberBreakthroughResult {

        let values = [
            input.bedDepth,
            input.bedCapacityDensity,
            input.inletConcentration,
            input.superficialVelocity,
            input.kineticConstant,
            input.breakthroughFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FixedBedAdsorberBreakthroughError
                .nonFiniteInput
        }

        guard
            input.bedDepth > 0,
            input.bedCapacityDensity > 0,
            input.inletConcentration > 0,
            input.superficialVelocity > 0,
            input.kineticConstant > 0
        else {
            throw FixedBedAdsorberBreakthroughError
                .nonPositiveInput
        }

        guard
            input.breakthroughFraction > 0,
            input.breakthroughFraction < 0.5
        else {
            throw FixedBedAdsorberBreakthroughError
                .invalidBreakthroughFraction
        }

        let capacityTerm =
            input.bedCapacityDensity
            * input.bedDepth
            / (
                input.inletConcentration
                * input.superficialVelocity
            )

        let kineticPenalty =
            1
            / (
                input.kineticConstant
                * input.inletConcentration
            )
            * Foundation.log(
                1
                / input.breakthroughFraction
                - 1
            )

        let breakthroughTime =
            capacityTerm
            - kineticPenalty

        guard breakthroughTime > 0 else {
            throw FixedBedAdsorberBreakthroughError
                .nonPositiveBreakthroughTime
        }

        let breakthroughConcentration =
            input.inletConcentration
            * input.breakthroughFraction

        let treatedIndex =
            input.superficialVelocity
            * breakthroughTime
            / input.bedDepth

        let outputs = [
            capacityTerm,
            kineticPenalty,
            breakthroughTime,
            breakthroughConcentration,
            treatedIndex
        ]

        guard outputs.allSatisfy(\.isFinite) else {
            throw FixedBedAdsorberBreakthroughError
                .numericalFailure
        }

        return .init(
            capacityTimeTerm:
                capacityTerm,
            kineticTimePenalty:
                kineticPenalty,
            breakthroughTime:
                breakthroughTime,
            breakthroughConcentration:
                breakthroughConcentration,
            treatedBedVolumesIndex:
                treatedIndex,
            modelName:
                "Bed-depth service-time adsorption model",
            limitationDescription:
                "Uses the BDST relation with constant inlet concentration, velocity, capacity density and kinetic coefficient."
        )
    }
}
