import Foundation

struct FixedBedAdsorptionBDSTEngine:
    Sendable {

    private let comparisonTolerance =
        1.0e-10

    func calculate(
        _ input:
            FixedBedAdsorptionBDSTInput
    ) throws
        -> FixedBedAdsorptionBDSTResult {

        let values = [
            input.bedDepth,
            input.columnCrossSectionalArea,
            input.superficialVelocity,
            input.influentConcentration,
            input.breakthroughConcentration,
            input.bedCapacityPerVolume,
            input.adsorptionRateConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                FixedBedAdsorptionBDSTError
                    .nonFiniteInput
        }

        guard
            input.bedDepth > 0,
            input.columnCrossSectionalArea
            > 0,
            input.superficialVelocity > 0,
            input.influentConcentration > 0,
            input.bedCapacityPerVolume > 0,
            input.adsorptionRateConstant > 0
        else {
            throw
                FixedBedAdsorptionBDSTError
                    .nonPositiveProperty
        }

        let breakthroughRatio =
            input.breakthroughConcentration
            / input.influentConcentration

        guard
            input.breakthroughConcentration
            > 0,
            breakthroughRatio > 0,
            breakthroughRatio < 0.5
        else {
            throw
                FixedBedAdsorptionBDSTError
                    .invalidBreakthroughRatio
        }

        let logarithmicTerm =
            log(
                input.influentConcentration
                / input.breakthroughConcentration
                - 1
            )

        let minimumBedDepth =
            input.superficialVelocity
            / (
                input.adsorptionRateConstant
                * input.bedCapacityPerVolume
            )
            * logarithmicTerm

        guard
            input.bedDepth
            >= minimumBedDepth
            - comparisonTolerance
        else {
            throw
                FixedBedAdsorptionBDSTError
                    .bedDepthBelowMinimum
        }

        let capacityTerm =
            input.bedCapacityPerVolume
            * input.bedDepth
            / (
                input.influentConcentration
                * input.superficialVelocity
            )

        let kineticTerm =
            logarithmicTerm
            / (
                input.adsorptionRateConstant
                * input.influentConcentration
            )

        var serviceTime =
            capacityTerm
            - kineticTerm

        if abs(serviceTime)
            <= comparisonTolerance {

            serviceTime = 0
        }

        let volumetricFlow =
            input.columnCrossSectionalArea
            * input.superficialVelocity

        let bedVolume =
            input.columnCrossSectionalArea
            * input.bedDepth

        let saturationCapacity =
            input.bedCapacityPerVolume
            * bedVolume

        let treatedVolume =
            volumetricFlow
            * serviceTime

        let nominalSoluteThroughput =
            input.influentConcentration
            * treatedVolume

        let nominalCapacityUtilization =
            saturationCapacity > 0
            ? nominalSoluteThroughput
                / saturationCapacity
            : 0

        let safetyMargin =
            input.bedDepth
            - minimumBedDepth

        let results = [
            breakthroughRatio,
            minimumBedDepth,
            serviceTime,
            safetyMargin,
            volumetricFlow,
            bedVolume,
            saturationCapacity,
            treatedVolume,
            nominalSoluteThroughput,
            nominalCapacityUtilization
        ]

        guard
            results.allSatisfy(\.isFinite),
            minimumBedDepth > 0,
            serviceTime >= 0,
            safetyMargin
            >= -comparisonTolerance,
            volumetricFlow > 0,
            bedVolume > 0,
            saturationCapacity > 0,
            treatedVolume >= 0,
            nominalSoluteThroughput >= 0,
            nominalCapacityUtilization >= 0
        else {
            throw
                FixedBedAdsorptionBDSTError
                    .numericalFailure
        }

        return
            FixedBedAdsorptionBDSTResult(
                breakthroughRatio:
                    breakthroughRatio,
                minimumBedDepth:
                    minimumBedDepth,
                serviceTimeToBreakthrough:
                    serviceTime,
                bedDepthSafetyMargin:
                    max(0, safetyMargin),
                volumetricFlowRate:
                    volumetricFlow,
                bedVolume:
                    bedVolume,
                bedSaturationCapacity:
                    saturationCapacity,
                treatedFluidVolume:
                    treatedVolume,
                nominalInfluentSoluteThroughput:
                    nominalSoluteThroughput,
                nominalCapacityUtilization:
                    nominalCapacityUtilization,
                modelName:
                    "Bed-depth service-time model for fixed-bed adsorption",
                limitationDescription:
                    "BDST parameters must be fitted for the same adsorbent, solute, temperature and hydrodynamic conditions. Axial dispersion, pressure drop and full breakthrough-curve shape are not modeled."
            )
    }
}
