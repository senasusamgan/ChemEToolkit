struct SpaceTimeSpaceVelocityEngine:
    Sendable {

    func calculate(
        _ input:
            SpaceTimeSpaceVelocityInput
    ) throws
        -> SpaceTimeSpaceVelocityResult {

        let values = [
            input.reactorVolume,
            input.inletVolumetricFlowRate,
            input.fluidHoldupFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SpaceTimeSpaceVelocityError
                .nonFiniteInput
        }

        guard
            input.reactorVolume > 0,
            input.inletVolumetricFlowRate > 0
        else {
            throw SpaceTimeSpaceVelocityError
                .nonPositiveVolumeOrFlow
        }

        guard
            input.fluidHoldupFraction > 0,
            input.fluidHoldupFraction <= 1
        else {
            throw SpaceTimeSpaceVelocityError
                .holdupFractionOutOfRange
        }

        let spaceTimeSeconds =
            input.reactorVolume
            / input.inletVolumetricFlowRate

        let spaceVelocityPerSecond =
            1 / spaceTimeSeconds

        let spaceTimeMinutes =
            spaceTimeSeconds / 60

        let spaceTimeHours =
            spaceTimeSeconds / 3600

        let spaceVelocityPerHour =
            spaceVelocityPerSecond
            * 3600

        let holdupVolume =
            input.fluidHoldupFraction
            * input.reactorVolume

        let holdupResidenceTime =
            holdupVolume
            / input.inletVolumetricFlowRate

        let interstitialSpaceVelocity =
            3600 / holdupResidenceTime

        let reactorVolumesPerDay =
            spaceVelocityPerSecond
            * 86_400

        let dailyThroughput =
            input.inletVolumetricFlowRate
            * 86_400

        let results = [
            spaceTimeSeconds,
            spaceTimeMinutes,
            spaceTimeHours,
            spaceVelocityPerSecond,
            spaceVelocityPerHour,
            holdupVolume,
            holdupResidenceTime,
            interstitialSpaceVelocity,
            reactorVolumesPerDay,
            dailyThroughput
        ]

        guard
            results.allSatisfy(\.isFinite),
            results.allSatisfy({ $0 > 0 })
        else {
            throw SpaceTimeSpaceVelocityError
                .numericalFailure
        }

        return .init(
            spaceTimeSeconds:
                spaceTimeSeconds,
            spaceTimeMinutes:
                spaceTimeMinutes,
            spaceTimeHours:
                spaceTimeHours,
            spaceVelocityPerSecond:
                spaceVelocityPerSecond,
            spaceVelocityPerHour:
                spaceVelocityPerHour,
            fluidHoldupVolume:
                holdupVolume,
            fluidHoldupResidenceTimeSeconds:
                holdupResidenceTime,
            interstitialSpaceVelocityPerHour:
                interstitialSpaceVelocity,
            reactorVolumesProcessedPerDay:
                reactorVolumesPerDay,
            dailyVolumetricThroughput:
                dailyThroughput,
            modelName:
                "Nominal space time and space velocity from inlet volumetric flow",
            limitationDescription:
                "Space time uses the inlet volumetric flow rate. It is not necessarily equal to the actual mean residence time when density, temperature, pressure, dispersion or phase holdup changes through the reactor."
        )
    }
}
