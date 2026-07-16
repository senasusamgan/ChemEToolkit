struct ZieglerNicholsReactionCurveTuningEngine:
    Sendable {

    func calculate(
        _ input:
            ZieglerNicholsReactionCurveTuningInput
    ) throws
        -> ZieglerNicholsReactionCurveTuningResult {

        let values = [
            input.processGain,
            input.processTimeConstant,
            input.processDeadTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ZieglerNicholsReactionCurveTuningError
                .nonFiniteInput
        }

        guard input.processGain != 0 else {
            throw ZieglerNicholsReactionCurveTuningError
                .zeroProcessGain
        }

        guard input.processTimeConstant > 0 else {
            throw ZieglerNicholsReactionCurveTuningError
                .nonPositiveTimeConstant
        }

        guard input.processDeadTime > 0 else {
            throw ZieglerNicholsReactionCurveTuningError
                .nonPositiveDeadTime
        }

        let baseGain =
            input.processTimeConstant
            / (
                input.processGain
                * input.processDeadTime
            )

        let proportionalGain =
            baseGain

        let piGain =
            0.9
            * baseGain

        let piIntegralTime =
            3.33
            * input.processDeadTime

        let pidGain =
            1.2
            * baseGain

        let pidIntegralTime =
            2
            * input.processDeadTime

        let pidDerivativeTime =
            0.5
            * input.processDeadTime

        let ratio =
            input.processDeadTime
            / input.processTimeConstant

        let description: String

        if ratio < 0.1 {
            description =
                "Small dead-time ratio: the process is comparatively easy to control."
        } else if ratio < 0.5 {
            description =
                "Moderate dead-time ratio: controller robustness requires attention."
        } else {
            description =
                "Large dead-time ratio: the process is difficult to control and aggressive tuning is risky."
        }

        let results = [
            proportionalGain,
            piGain,
            piIntegralTime,
            pidGain,
            pidIntegralTime,
            pidDerivativeTime,
            ratio
        ]

        guard
            results.allSatisfy(\.isFinite),
            piIntegralTime > 0,
            pidIntegralTime > 0,
            pidDerivativeTime > 0,
            ratio > 0
        else {
            throw ZieglerNicholsReactionCurveTuningError
                .numericalFailure
        }

        return .init(
            proportionalGain:
                proportionalGain,
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
            deadTimeRatio:
                ratio,
            processControllabilityDescription:
                description,
            modelName:
                "Ziegler–Nichols open-loop reaction-curve tuning for an FOPDT process",
            limitationDescription:
                "Uses fitted process gain K, time constant τ and dead time θ. Signed controller gains preserve the process-gain sign; verify the direct/reverse-action convention in the target control system."
        )
    }
}
