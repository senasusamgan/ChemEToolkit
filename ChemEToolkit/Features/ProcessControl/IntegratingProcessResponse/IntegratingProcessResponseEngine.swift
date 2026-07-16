struct IntegratingProcessResponseEngine:
    Sendable {

    private let zeroTolerance =
        1e-14

    func calculate(
        _ input:
            IntegratingProcessResponseInput
    ) throws
        -> IntegratingProcessResponseResult {

        let values = [
            input.initialOutput,
            input.integratingGain,
            input.inputStepChange,
            input.deadTime,
            input.evaluationTime,
            input.targetOutput
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IntegratingProcessResponseError
                .nonFiniteInput
        }

        guard input.deadTime >= 0 else {
            throw IntegratingProcessResponseError
                .negativeDeadTime
        }

        guard input.evaluationTime >= 0 else {
            throw IntegratingProcessResponseError
                .negativeEvaluationTime
        }

        let slope =
            input.integratingGain
            * input.inputStepChange

        let started =
            input.evaluationTime
            >= input.deadTime

        let activeTime =
            max(
                0,
                input.evaluationTime
                - input.deadTime
            )

        let output =
            input.initialOutput
            + slope
            * activeTime

        let targetDifference =
            input.targetOutput
            - input.initialOutput

        let targetReachable: Bool
        let targetTime: Double?

        if abs(targetDifference)
            <= zeroTolerance {
            targetReachable = true
            targetTime = 0
        } else if abs(slope)
            <= zeroTolerance {
            targetReachable = false
            targetTime = nil
        } else {
            let requiredActiveTime =
                targetDifference / slope

            if requiredActiveTime >= 0 {
                targetReachable = true
                targetTime =
                    input.deadTime
                    + requiredActiveTime
            } else {
                targetReachable = false
                targetTime = nil
            }
        }

        let remainingTime: Double?

        if let targetTime {
            remainingTime =
                max(
                    0,
                    targetTime
                    - input.evaluationTime
                )
        } else {
            remainingTime = nil
        }

        let direction: String

        if slope > 0 {
            direction =
                "The process output ramps upward after the dead time."
        } else if slope < 0 {
            direction =
                "The process output ramps downward after the dead time."
        } else {
            direction =
                "The selected gain and input step produce no integrating ramp."
        }

        let results = [
            output,
            slope,
            activeTime
        ]

        guard
            results.allSatisfy(\.isFinite),
            activeTime >= 0
        else {
            throw IntegratingProcessResponseError
                .numericalFailure
        }

        if let targetTime {
            guard
                targetTime.isFinite,
                targetTime >= 0
            else {
                throw IntegratingProcessResponseError
                    .numericalFailure
            }
        }

        if let remainingTime {
            guard
                remainingTime.isFinite,
                remainingTime >= 0
            else {
                throw IntegratingProcessResponseError
                    .numericalFailure
            }
        }

        return .init(
            outputAtEvaluationTime:
                output,
            outputRateOfChange:
                slope,
            responseHasStarted:
                started,
            activeIntegrationTime:
                activeTime,
            targetIsReachable:
                targetReachable,
            targetReachTime:
                targetTime,
            timeRemainingToTarget:
                remainingTime,
            responseDirectionDescription:
                direction,
            modelName:
                "Integrating-process response with dead time: y(t)=y₀+KᵢΔu·max(0,t−θ)",
            limitationDescription:
                "Assumes a constant input step, constant integrating gain and no self-regulation or output constraints. Real tank levels and inventories require physical upper and lower bounds."
        )
    }
}
