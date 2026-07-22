struct AdaptiveControlEngine:
    Sendable {

    private let zeroTolerance =
        1e-14

    func calculate(
        _ input:
            AdaptiveControlInput
    ) throws
        -> AdaptiveControlResult {

        let values = [
            input.currentControllerGain,
            input.referenceOutput,
            input.measuredOutput,
            input.modelOutputSensitivity,
            input.adaptationRate,
            input.sampleTime,
            input.minimumControllerGain,
            input.maximumControllerGain
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AdaptiveControlError
                .nonFiniteInput
        }

        guard input.adaptationRate >= 0 else {
            throw AdaptiveControlError
                .negativeAdaptationRate
        }

        guard input.sampleTime > 0 else {
            throw AdaptiveControlError
                .nonPositiveSampleTime
        }

        guard
            input.minimumControllerGain
            < input.maximumControllerGain
        else {
            throw AdaptiveControlError
                .invalidGainLimits
        }

        let trackingError =
            input.referenceOutput
            - input.measuredOutput

        let adaptationSignal =
            trackingError
            * input.modelOutputSensitivity

        let requestedUpdate =
            input.adaptationRate
            * adaptationSignal
            * input.sampleTime

        let unconstrainedGain =
            input.currentControllerGain
            + requestedUpdate

        let updatedGain =
            min(
                input.maximumControllerGain,
                max(
                    input.minimumControllerGain,
                    unconstrainedGain
                )
            )

        let appliedUpdate =
            updatedGain
            - input.currentControllerGain

        let predictedOutputChange =
            input.modelOutputSensitivity
            * appliedUpdate

        let predictedError =
            trackingError
            - predictedOutputChange

        let currentCost =
            0.5
            * trackingError
            * trackingError

        let predictedCost =
            0.5
            * predictedError
            * predictedError

        let improvement: Double

        if currentCost > zeroTolerance {
            improvement =
                (
                    currentCost
                    - predictedCost
                )
                / currentCost
        } else {
            improvement = 0
        }

        let description: String

        if input.adaptationRate == 0 {
            description =
                "Adaptation disabled: controller gain remains unchanged."
        } else if updatedGain
            != unconstrainedGain {
            description =
                "Adaptive update reached a controller-gain limit."
        } else if predictedCost < currentCost {
            description =
                "The local sensitivity model predicts improved tracking after this update."
        } else if predictedCost > currentCost {
            description =
                "The local sensitivity model predicts worse tracking; verify sensitivity sign and adaptation rate."
        } else {
            description =
                "The update has no predicted effect on tracking cost."
        }

        let results = [
            trackingError,
            adaptationSignal,
            requestedUpdate,
            appliedUpdate,
            unconstrainedGain,
            updatedGain,
            currentCost,
            predictedError,
            predictedCost,
            improvement
        ]

        guard
            results.allSatisfy(\.isFinite),
            updatedGain
                >= input.minimumControllerGain,
            updatedGain
                <= input.maximumControllerGain,
            currentCost >= 0,
            predictedCost >= 0
        else {
            throw AdaptiveControlError
                .numericalFailure
        }

        return .init(
            trackingError:
                trackingError,
            adaptationSignal:
                adaptationSignal,
            requestedGainUpdate:
                requestedUpdate,
            appliedGainUpdate:
                appliedUpdate,
            unconstrainedUpdatedGain:
                unconstrainedGain,
            updatedControllerGain:
                updatedGain,
            currentTrackingCost:
                currentCost,
            predictedTrackingError:
                predictedError,
            predictedTrackingCost:
                predictedCost,
            predictedImprovementFraction:
                improvement,
            gainLimitIsActive:
                updatedGain
                != unconstrainedGain,
            adaptationDescription:
                description,
            modelName:
                "Single-step gradient adaptive-gain update using a local output-sensitivity model",
            limitationDescription:
                "This educational update is not a full self-tuning regulator or model-reference adaptive controller. Stability requires persistent excitation, valid sensitivity information, projection limits and appropriate adaptation-rate design."
        )
    }
}
