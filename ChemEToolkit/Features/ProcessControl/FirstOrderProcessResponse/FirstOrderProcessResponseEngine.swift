import Foundation

struct FirstOrderProcessResponseEngine:
    Sendable {

    func calculate(
        _ input:
            FirstOrderProcessResponseInput
    ) throws
        -> FirstOrderProcessResponseResult {

        let values = [
            input.initialOutput,
            input.processGain,
            input.inputStepChange,
            input.timeConstant,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FirstOrderProcessResponseError
                .nonFiniteInput
        }

        guard input.timeConstant > 0 else {
            throw FirstOrderProcessResponseError
                .nonPositiveTimeConstant
        }

        guard input.evaluationTime >= 0 else {
            throw FirstOrderProcessResponseError
                .negativeEvaluationTime
        }

        let finalChange =
            input.processGain
            * input.inputStepChange

        let decay =
            exp(
                -input.evaluationTime
                / input.timeConstant
            )

        let fractionCompleted =
            1 - decay

        let responseChange =
            finalChange
            * fractionCompleted

        let output =
            input.initialOutput
            + responseChange

        let finalOutput =
            input.initialOutput
            + finalChange

        let initialSlope =
            finalChange
            / input.timeConstant

        let direction: String

        if finalChange > 0 {
            direction =
                "The process output increases toward the new steady state."
        } else if finalChange < 0 {
            direction =
                "The process output decreases toward the new steady state."
        } else {
            direction =
                "The selected gain and input step produce no output change."
        }

        let results = [
            output,
            finalOutput,
            responseChange,
            fractionCompleted,
            decay,
            initialSlope
        ]

        guard
            results.allSatisfy(\.isFinite),
            fractionCompleted >= 0,
            fractionCompleted <= 1,
            decay >= 0,
            decay <= 1
        else {
            throw FirstOrderProcessResponseError
                .numericalFailure
        }

        return .init(
            outputAtEvaluationTime:
                output,
            finalSteadyStateOutput:
                finalOutput,
            responseChange:
                responseChange,
            fractionOfFinalChange:
                fractionCompleted,
            remainingErrorFraction:
                decay,
            initialResponseSlope:
                initialSlope,
            halfResponseTime:
                input.timeConstant
                * log(2),
            fivePercentSettlingTime:
                3
                * input.timeConstant,
            twoPercentSettlingTime:
                4
                * input.timeConstant,
            responseDirectionDescription:
                direction,
            modelName:
                "First-order step response: y(t) = y₀ + KΔu[1−exp(−t/τ)]",
            limitationDescription:
                "Assumes a linear, time-invariant, self-regulating first-order process with an instantaneous input step and no dead time."
        )
    }
}
