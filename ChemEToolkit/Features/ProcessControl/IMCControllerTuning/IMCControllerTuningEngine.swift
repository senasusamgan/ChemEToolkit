struct IMCControllerTuningEngine:
    Sendable {

    func calculate(
        _ input:
            IMCControllerTuningInput
    ) throws
        -> IMCControllerTuningResult {

        let values = [
            input.processGain,
            input.processTimeConstant,
            input.processDeadTime,
            input.closedLoopTimeConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IMCControllerTuningError
                .nonFiniteInput
        }

        guard input.processGain != 0 else {
            throw IMCControllerTuningError
                .zeroProcessGain
        }

        guard input.processTimeConstant > 0 else {
            throw IMCControllerTuningError
                .nonPositiveTimeConstant
        }

        guard input.processDeadTime >= 0 else {
            throw IMCControllerTuningError
                .negativeDeadTime
        }

        guard
            input.closedLoopTimeConstant > 0
        else {
            throw IMCControllerTuningError
                .nonPositiveClosedLoopTimeConstant
        }

        let piGain =
            input.processTimeConstant
            / (
                input.processGain
                * (
                    input.closedLoopTimeConstant
                    + input.processDeadTime
                )
            )

        let piIntegralTime =
            input.processTimeConstant

        let halfDeadTime =
            input.processDeadTime / 2

        let pidGain =
            (
                input.processTimeConstant
                + halfDeadTime
            )
            / (
                input.processGain
                * (
                    input.closedLoopTimeConstant
                    + halfDeadTime
                )
            )

        let pidIntegralTime =
            input.processTimeConstant
            + halfDeadTime

        let pidDerivativeTime =
            input.processTimeConstant
            * input.processDeadTime
            / (
                2
                * input.processTimeConstant
                + input.processDeadTime
            )

        let ratio =
            input.processDeadTime > 0
            ? input.closedLoopTimeConstant
                / input.processDeadTime
            : .infinity

        let description: String

        if input.processDeadTime == 0 {
            description =
                "No modeled dead time: λ directly sets the desired response speed."
        } else if ratio < 1 {
            description =
                "Aggressive IMC choice: λ is smaller than the process dead time."
        } else if ratio <= 3 {
            description =
                "Balanced IMC choice: response speed and robustness are comparable."
        } else {
            description =
                "Conservative IMC choice: larger λ favors robustness and smoother control action."
        }

        let finiteResults = [
            piGain,
            piIntegralTime,
            pidGain,
            pidIntegralTime,
            pidDerivativeTime
        ]

        guard
            finiteResults.allSatisfy(\.isFinite),
            piIntegralTime > 0,
            pidIntegralTime > 0,
            pidDerivativeTime >= 0
        else {
            throw IMCControllerTuningError
                .numericalFailure
        }

        return .init(
            piGain:
                piGain,
            piIntegralTime:
                piIntegralTime,
            pidGain:
                pidGain,
            pidIntegralTime:
                pidIntegralTime,
            pidDerivativeTime:
                pidDerivativeTime,
            lambdaToDeadTimeRatio:
                ratio,
            robustnessDescription:
                description,
            modelName:
                "IMC-based PI and PID tuning for a first-order-plus-dead-time process",
            limitationDescription:
                "The tuning parameter λ trades response speed for robustness. These formulas assume an adequate FOPDT model and use an ideal-controller form; confirm compatibility with the implemented PID structure."
        )
    }
}
