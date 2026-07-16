import Foundation

struct OpenLoopResponseEngine: Sendable {
    func calculate(
        _ input: OpenLoopResponseInput
    ) throws -> OpenLoopResponseResult {

        let values = [
            input.initialProcessOutput,
            input.controllerBias,
            input.controllerGain,
            input.referenceStepChange,
            input.minimumControllerOutput,
            input.maximumControllerOutput,
            input.processGain,
            input.processTimeConstant,
            input.processDeadTime,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw OpenLoopResponseError.nonFiniteInput
        }

        guard
            input.minimumControllerOutput
            < input.maximumControllerOutput
        else {
            throw OpenLoopResponseError.invalidControllerLimits
        }

        guard input.processTimeConstant > 0 else {
            throw OpenLoopResponseError.nonPositiveProcessTimeConstant
        }

        guard input.processDeadTime >= 0 else {
            throw OpenLoopResponseError.negativeProcessDeadTime
        }

        guard input.evaluationTime >= 0 else {
            throw OpenLoopResponseError.negativeEvaluationTime
        }

        let requested =
            input.controllerBias
            + input.controllerGain
            * input.referenceStepChange

        let applied =
            min(
                input.maximumControllerOutput,
                max(
                    input.minimumControllerOutput,
                    requested
                )
            )

        let manipulatedChange =
            applied
            - input.controllerBias

        let openLoopGain =
            input.controllerGain
            * input.processGain

        let finalOutput =
            input.initialProcessOutput
            + input.processGain
            * manipulatedChange

        let started =
            input.evaluationTime
            >= input.processDeadTime

        let activeTime =
            max(
                0,
                input.evaluationTime
                - input.processDeadTime
            )

        let fraction =
            started
            ? 1
                - exp(
                    -activeTime
                    / input.processTimeConstant
                )
            : 0

        let output =
            input.initialProcessOutput
            + input.processGain
            * manipulatedChange
            * fraction

        let results = [
            requested,
            applied,
            manipulatedChange,
            openLoopGain,
            output,
            finalOutput,
            fraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            fraction >= 0,
            fraction <= 1,
            applied >= input.minimumControllerOutput,
            applied <= input.maximumControllerOutput
        else {
            throw OpenLoopResponseError.numericalFailure
        }

        return .init(
            requestedControllerOutput: requested,
            appliedControllerOutput: applied,
            appliedManipulatedChange: manipulatedChange,
            openLoopGain: openLoopGain,
            processOutputAtEvaluationTime: output,
            finalProcessOutput: finalOutput,
            responseHasStarted: started,
            fractionOfFinalChange: fraction,
            controllerIsSaturated:
                requested != applied,
            modelName:
                "Open-loop controller and FOPDT process response",
            limitationDescription:
                "The controller acts only once on the reference step; process output is not measured or fed back. Disturbances and modeling error therefore remain uncorrected."
        )
    }
}
