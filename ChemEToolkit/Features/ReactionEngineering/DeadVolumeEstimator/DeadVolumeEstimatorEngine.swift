struct DeadVolumeEstimatorEngine:
    Sendable {

    private let rangeTolerance =
        1.0e-12

    func calculate(
        _ input:
            DeadVolumeEstimatorInput
    ) throws
        -> DeadVolumeEstimatorResult {

        let values = [
            input.nominalReactorVolume,
            input.volumetricFlowRate,
            input.measuredMeanResidenceTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw DeadVolumeEstimatorError
                .nonFiniteInput
        }

        guard
            input.nominalReactorVolume > 0,
            input.volumetricFlowRate > 0
        else {
            throw DeadVolumeEstimatorError
                .nonPositiveVolumeOrFlow
        }

        guard
            input.measuredMeanResidenceTime >= 0
        else {
            throw DeadVolumeEstimatorError
                .negativeMeanResidenceTime
        }

        let nominalSpaceTime =
            input.nominalReactorVolume
            / input.volumetricFlowRate

        guard
            input.measuredMeanResidenceTime
            <= nominalSpaceTime
            * (
                1 + rangeTolerance
            )
        else {
            throw DeadVolumeEstimatorError
                .measuredResidenceTimeExceedsNominal
        }

        let activeVolume =
            input.volumetricFlowRate
            * input.measuredMeanResidenceTime

        let deadVolume =
            max(
                0,
                input.nominalReactorVolume
                - activeVolume
            )

        let activeFraction =
            activeVolume
            / input.nominalReactorVolume

        let deadFraction =
            deadVolume
            / input.nominalReactorVolume

        let residenceTimeRatio =
            input.measuredMeanResidenceTime
            / nominalSpaceTime

        let results = [
            nominalSpaceTime,
            activeVolume,
            deadVolume,
            activeFraction,
            deadFraction,
            residenceTimeRatio
        ]

        guard
            results.allSatisfy(\.isFinite),
            nominalSpaceTime > 0,
            activeVolume >= 0,
            deadVolume >= 0,
            activeFraction >= 0,
            activeFraction <= 1
                + rangeTolerance,
            deadFraction >= 0,
            deadFraction <= 1
                + rangeTolerance
        else {
            throw DeadVolumeEstimatorError
                .numericalFailure
        }

        return .init(
            nominalSpaceTime:
                nominalSpaceTime,
            measuredMeanResidenceTime:
                input.measuredMeanResidenceTime,
            activeVolume:
                activeVolume,
            deadVolume:
                deadVolume,
            activeVolumeFraction:
                activeFraction,
            deadVolumeFraction:
                deadFraction,
            residenceTimeRatio:
                residenceTimeRatio,
            modelName:
                "Dead-volume estimate from V_active = Q·t̄",
            limitationDescription:
                "Attributes the entire reduction in mean residence time to inaccessible dead volume. Bypass flow, tracer loss, density change and recirculation are not separated by this model."
        )
    }
}
