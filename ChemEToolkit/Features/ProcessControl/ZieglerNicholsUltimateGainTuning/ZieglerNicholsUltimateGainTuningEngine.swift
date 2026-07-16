struct ZieglerNicholsUltimateGainTuningEngine:
    Sendable {

    func calculate(
        _ input:
            ZieglerNicholsUltimateGainTuningInput
    ) throws
        -> ZieglerNicholsUltimateGainTuningResult {

        let values = [
            input.ultimateGain,
            input.ultimatePeriod
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ZieglerNicholsUltimateGainTuningError
                .nonFiniteInput
        }

        guard input.ultimateGain > 0 else {
            throw ZieglerNicholsUltimateGainTuningError
                .nonPositiveUltimateGain
        }

        guard input.ultimatePeriod > 0 else {
            throw ZieglerNicholsUltimateGainTuningError
                .nonPositiveUltimatePeriod
        }

        let proportionalGain =
            0.5
            * input.ultimateGain

        let piGain =
            0.45
            * input.ultimateGain

        let piIntegralTime =
            input.ultimatePeriod
            / 1.2

        let pidGain =
            0.6
            * input.ultimateGain

        let pidIntegralTime =
            input.ultimatePeriod
            / 2

        let pidDerivativeTime =
            input.ultimatePeriod
            / 8

        let ultimateFrequency =
            2
            * Double.pi
            / input.ultimatePeriod

        let results = [
            proportionalGain,
            piGain,
            piIntegralTime,
            pidGain,
            pidIntegralTime,
            pidDerivativeTime,
            ultimateFrequency
        ]

        guard
            results.allSatisfy(\.isFinite),
            results.allSatisfy({ $0 > 0 })
        else {
            throw ZieglerNicholsUltimateGainTuningError
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
            ultimateFrequency:
                ultimateFrequency,
            tuningAggressivenessDescription:
                "Classic quarter-amplitude-decay tuning; expect an aggressive closed-loop response.",
            modelName:
                "Ziegler–Nichols closed-loop ultimate-gain tuning",
            limitationDescription:
                "Requires a trustworthy ultimate gain K_u and sustained-oscillation period P_u. The test can be unsafe on an operating plant, and the classic settings often produce substantial overshoot."
        )
    }
}
