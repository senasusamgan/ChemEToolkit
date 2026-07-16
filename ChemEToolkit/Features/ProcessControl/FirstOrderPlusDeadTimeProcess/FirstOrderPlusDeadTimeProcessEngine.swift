import Foundation

struct FirstOrderPlusDeadTimeProcessEngine:
    Sendable {

    func calculate(
        _ input:
            FirstOrderPlusDeadTimeProcessInput
    ) throws
        -> FirstOrderPlusDeadTimeProcessResult {

        let values = [
            input.initialOutput,
            input.processGain,
            input.inputStepChange,
            input.timeConstant,
            input.deadTime,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FirstOrderPlusDeadTimeProcessError
                .nonFiniteInput
        }

        guard input.timeConstant > 0 else {
            throw FirstOrderPlusDeadTimeProcessError
                .nonPositiveTimeConstant
        }

        guard input.deadTime >= 0 else {
            throw FirstOrderPlusDeadTimeProcessError
                .negativeDeadTime
        }

        guard input.evaluationTime >= 0 else {
            throw FirstOrderPlusDeadTimeProcessError
                .negativeEvaluationTime
        }

        let finalChange =
            input.processGain
            * input.inputStepChange

        let finalOutput =
            input.initialOutput
            + finalChange

        let responseStarted =
            input.evaluationTime
            >= input.deadTime

        let activeTime =
            max(
                0,
                input.evaluationTime
                - input.deadTime
            )

        let decay =
            responseStarted
            ? exp(
                -activeTime
                / input.timeConstant
            )
            : 1

        let completed =
            responseStarted
            ? 1 - decay
            : 0

        let output =
            input.initialOutput
            + finalChange
            * completed

        let ratio =
            input.deadTime
            / input.timeConstant

        let results = [
            output,
            finalOutput,
            activeTime,
            completed,
            decay,
            ratio
        ]

        guard
            results.allSatisfy(\.isFinite),
            activeTime >= 0,
            completed >= 0,
            completed <= 1,
            decay >= 0,
            decay <= 1,
            ratio >= 0
        else {
            throw FirstOrderPlusDeadTimeProcessError
                .numericalFailure
        }

        return .init(
            outputAtEvaluationTime:
                output,
            finalSteadyStateOutput:
                finalOutput,
            responseHasStarted:
                responseStarted,
            activeResponseTime:
                activeTime,
            fractionOfFinalChange:
                completed,
            remainingErrorFraction:
                decay,
            deadTimeToTimeConstantRatio:
                ratio,
            fivePercentSettlingTime:
                input.deadTime
                + 3
                * input.timeConstant,
            twoPercentSettlingTime:
                input.deadTime
                + 4
                * input.timeConstant,
            modelName:
                "FOPDT response: y(t)=y₀ for t<θ; y(t)=y₀+KΔu[1−exp(−(t−θ)/τ)] for t≥θ",
            limitationDescription:
                "Assumes a linear first-order self-regulating process with a pure transport delay. Higher-order dynamics are represented only through the fitted gain, time constant and dead time."
        )
    }
}
