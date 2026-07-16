import Foundation

struct SmithPredictorEngine:
    Sendable {

    func calculate(
        _ input:
            SmithPredictorInput
    ) throws
        -> SmithPredictorResult {

        let values = [
            input.initialOutput,
            input.manipulatedVariableStep,
            input.actualProcessGain,
            input.actualTimeConstant,
            input.actualDeadTime,
            input.modelProcessGain,
            input.modelTimeConstant,
            input.modelDeadTime,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SmithPredictorError
                .nonFiniteInput
        }

        guard
            input.actualTimeConstant > 0,
            input.modelTimeConstant > 0
        else {
            throw SmithPredictorError
                .nonPositiveTimeConstant
        }

        guard
            input.actualDeadTime >= 0,
            input.modelDeadTime >= 0
        else {
            throw SmithPredictorError
                .negativeDeadTime
        }

        guard input.evaluationTime >= 0 else {
            throw SmithPredictorError
                .negativeEvaluationTime
        }

        let actualStarted =
            input.evaluationTime
            >= input.actualDeadTime

        let modelStarted =
            input.evaluationTime
            >= input.modelDeadTime

        let actualActiveTime =
            max(
                0,
                input.evaluationTime
                - input.actualDeadTime
            )

        let modelActiveTime =
            max(
                0,
                input.evaluationTime
                - input.modelDeadTime
            )

        let actualFraction =
            actualStarted
            ? 1
                - exp(
                    -actualActiveTime
                    / input.actualTimeConstant
                )
            : 0

        let modelDelayedFraction =
            modelStarted
            ? 1
                - exp(
                    -modelActiveTime
                    / input.modelTimeConstant
                )
            : 0

        let modelNoDelayFraction =
            1
            - exp(
                -input.evaluationTime
                / input.modelTimeConstant
            )

        let actualOutput =
            input.initialOutput
            + input.actualProcessGain
            * input.manipulatedVariableStep
            * actualFraction

        let modelDelayedOutput =
            input.initialOutput
            + input.modelProcessGain
            * input.manipulatedVariableStep
            * modelDelayedFraction

        let modelNoDelayOutput =
            input.initialOutput
            + input.modelProcessGain
            * input.manipulatedVariableStep
            * modelNoDelayFraction

        let correction =
            actualOutput
            - modelDelayedOutput

        let smithPrediction =
            modelNoDelayOutput
            + correction

        let predictionError =
            actualOutput
            - smithPrediction

        let gainRelativeError =
            input.actualProcessGain != 0
            ? abs(
                (
                    input.modelProcessGain
                    - input.actualProcessGain
                )
                / input.actualProcessGain
            )
            : abs(
                input.modelProcessGain
                - input.actualProcessGain
            )

        let timeRelativeError =
            abs(
                (
                    input.modelTimeConstant
                    - input.actualTimeConstant
                )
                / input.actualTimeConstant
            )

        let deadTimeScale =
            max(
                1e-12,
                input.actualDeadTime
            )

        let deadTimeRelativeError =
            input.actualDeadTime > 0
            ? abs(
                (
                    input.modelDeadTime
                    - input.actualDeadTime
                )
                / deadTimeScale
            )
            : abs(
                input.modelDeadTime
                - input.actualDeadTime
            )

        let largestMismatch =
            max(
                gainRelativeError,
                timeRelativeError,
                deadTimeRelativeError
            )

        let adequacy: String

        if largestMismatch < 0.05 {
            adequacy =
                "Close model match: predictor correction should remain small."
        } else if largestMismatch < 0.20 {
            adequacy =
                "Moderate model mismatch: monitor prediction correction and closed-loop robustness."
        } else {
            adequacy =
                "Large model mismatch: Smith-predictor performance may degrade significantly."
        }

        let results = [
            actualOutput,
            modelDelayedOutput,
            modelNoDelayOutput,
            correction,
            smithPrediction,
            predictionError
        ]

        guard
            results.allSatisfy(\.isFinite),
            actualFraction >= 0,
            actualFraction <= 1,
            modelDelayedFraction >= 0,
            modelDelayedFraction <= 1,
            modelNoDelayFraction >= 0,
            modelNoDelayFraction <= 1
        else {
            throw SmithPredictorError
                .numericalFailure
        }

        return .init(
            actualDelayedOutput:
                actualOutput,
            modelDelayedOutput:
                modelDelayedOutput,
            modelDeadTimeFreeOutput:
                modelNoDelayOutput,
            modelMismatchCorrection:
                correction,
            smithPredictedOutput:
                smithPrediction,
            predictionError:
                predictionError,
            actualResponseHasStarted:
                actualStarted,
            modelResponseHasStarted:
                modelStarted,
            modelAdequacyDescription:
                adequacy,
            modelName:
                "Smith predictor estimate: ŷ_SP = ŷ_model,no-delay + (y_actual − ŷ_model,delayed)",
            limitationDescription:
                "Demonstrates predictor reconstruction for a step-driven FOPDT process. It does not simulate a complete feedback controller, measurement noise, nonlinearities or model adaptation."
        )
    }
}
