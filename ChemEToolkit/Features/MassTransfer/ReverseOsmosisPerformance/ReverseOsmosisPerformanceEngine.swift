struct ReverseOsmosisPerformanceEngine:
    Sendable {

    private let maximumRecovery =
        0.25

    private let tolerance =
        1.0e-12

    func calculate(
        _ input:
            ReverseOsmosisPerformanceInput
    ) throws
        -> ReverseOsmosisPerformanceResult {

        let values = [
            input.feedVolumetricFlowRate,
            input.membraneArea,
            input.waterPermeabilityLMHPerBar,
            input.appliedPressureDifferenceBar,
            input.osmoticPressureDifferenceBar,
            input.solutePermeabilityMetersPerHour,
            input.feedSoluteConcentration
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReverseOsmosisPerformanceError
                .nonFiniteInput
        }

        guard
            input.feedVolumetricFlowRate > 0,
            input.membraneArea > 0,
            input.waterPermeabilityLMHPerBar > 0,
            input.appliedPressureDifferenceBar > 0,
            input.solutePermeabilityMetersPerHour > 0,
            input.feedSoluteConcentration > 0
        else {
            throw ReverseOsmosisPerformanceError
                .nonPositiveProperty
        }

        guard
            input.osmoticPressureDifferenceBar >= 0
        else {
            throw ReverseOsmosisPerformanceError
                .negativeOsmoticPressureDifference
        }

        let netDrivingPressure =
            input.appliedPressureDifferenceBar
            - input.osmoticPressureDifferenceBar

        guard netDrivingPressure > 0 else {
            throw ReverseOsmosisPerformanceError
                .insufficientNetDrivingPressure
        }

        let waterPermeabilityMetersPerHourPerBar =
            input.waterPermeabilityLMHPerBar
            / 1000

        let waterFlux =
            waterPermeabilityMetersPerHourPerBar
            * netDrivingPressure

        let permeateFlow =
            waterFlux
            * input.membraneArea

        let recovery =
            permeateFlow
            / input.feedVolumetricFlowRate

        guard
            recovery <= maximumRecovery
            + tolerance
        else {
            throw ReverseOsmosisPerformanceError
                .recoveryOutsideLowRecoveryModel
        }

        let concentrateFlow =
            input.feedVolumetricFlowRate
            - permeateFlow

        guard concentrateFlow > 0 else {
            throw ReverseOsmosisPerformanceError
                .numericalFailure
        }

        let permeateConcentration =
            input.solutePermeabilityMetersPerHour
            * input.feedSoluteConcentration
            / (
                waterFlux
                + input.solutePermeabilityMetersPerHour
            )

        let rejection =
            1
            - permeateConcentration
            / input.feedSoluteConcentration

        let concentrateConcentration =
            (
                input.feedVolumetricFlowRate
                * input.feedSoluteConcentration
                - permeateFlow
                * permeateConcentration
            )
            / concentrateFlow

        let permeateSoluteRecovery =
            permeateFlow
            * permeateConcentration
            / (
                input.feedVolumetricFlowRate
                * input.feedSoluteConcentration
            )

        let concentrationFactor =
            concentrateConcentration
            / input.feedSoluteConcentration

        let soluteResidual =
            input.feedVolumetricFlowRate
            * input.feedSoluteConcentration
            - permeateFlow
            * permeateConcentration
            - concentrateFlow
            * concentrateConcentration

        let results = [
            netDrivingPressure,
            waterFlux,
            permeateFlow,
            concentrateFlow,
            recovery,
            permeateConcentration,
            concentrateConcentration,
            rejection,
            permeateSoluteRecovery,
            concentrationFactor,
            soluteResidual
        ]

        guard
            results.allSatisfy(\.isFinite),
            waterFlux > 0,
            permeateFlow > 0,
            recovery > 0,
            recovery <= 1,
            permeateConcentration >= 0,
            concentrateConcentration > 0,
            rejection >= 0,
            rejection <= 1,
            permeateSoluteRecovery >= 0,
            permeateSoluteRecovery <= 1,
            concentrationFactor >= 1
        else {
            throw ReverseOsmosisPerformanceError
                .numericalFailure
        }

        return ReverseOsmosisPerformanceResult(
            netDrivingPressureBar:
                netDrivingPressure,
            waterFluxMetersPerHour:
                waterFlux,
            waterFluxLMH:
                1000 * waterFlux,
            permeateFlowRate:
                permeateFlow,
            concentrateFlowRate:
                concentrateFlow,
            waterRecoveryFraction:
                recovery,
            permeateSoluteConcentration:
                permeateConcentration,
            concentrateSoluteConcentration:
                concentrateConcentration,
            observedSoluteRejection:
                rejection,
            permeateSoluteRecoveryFraction:
                permeateSoluteRecovery,
            concentrationFactor:
                concentrationFactor,
            soluteBalanceResidual:
                soluteResidual,
            modelName:
                "Low-recovery solution–diffusion reverse-osmosis model",
            limitationDescription:
                "Uses constant feed-side concentration, specified osmotic-pressure difference, no concentration polarization, no pressure drop and no membrane compaction."
        )
    }
}
