struct CohenCoonTuningEngine:
    Sendable {

    func calculate(
        _ input:
            CohenCoonTuningInput
    ) throws
        -> CohenCoonTuningResult {

        let values = [
            input.processGain,
            input.processTimeConstant,
            input.processDeadTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CohenCoonTuningError
                .nonFiniteInput
        }

        guard input.processGain != 0 else {
            throw CohenCoonTuningError
                .zeroProcessGain
        }

        guard input.processTimeConstant > 0 else {
            throw CohenCoonTuningError
                .nonPositiveTimeConstant
        }

        guard input.processDeadTime > 0 else {
            throw CohenCoonTuningError
                .nonPositiveDeadTime
        }

        let ratio =
            input.processDeadTime
            / input.processTimeConstant

        guard ratio <= 1 else {
            throw CohenCoonTuningError
                .deadTimeRatioOutOfRange
        }

        let inverseScaledGain =
            1
            / (
                input.processGain
                * ratio
            )

        let proportionalGain =
            inverseScaledGain
            * (
                1
                + ratio / 3
            )

        let piGain =
            inverseScaledGain
            * (
                0.9
                + ratio / 12
            )

        let piIntegralTime =
            input.processDeadTime
            * (
                30
                + 3 * ratio
            )
            / (
                9
                + 20 * ratio
            )

        let pidGain =
            inverseScaledGain
            * (
                4.0 / 3.0
                + ratio / 4
            )

        let pidIntegralTime =
            input.processDeadTime
            * (
                32
                + 6 * ratio
            )
            / (
                13
                + 8 * ratio
            )

        let pidDerivativeTime =
            input.processDeadTime
            * 4
            / (
                11
                + 2 * ratio
            )

        let description: String

        if ratio < 0.1 {
            description =
                "Very small dead-time ratio: Cohen–Coon may be unnecessarily aggressive compared with robust IMC tuning."
        } else if ratio <= 0.5 {
            description =
                "Moderate dead-time ratio: a typical Cohen–Coon application range."
        } else {
            description =
                "Large dead-time ratio: validate robustness carefully before implementation."
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
            throw CohenCoonTuningError
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
            applicabilityDescription:
                description,
            modelName:
                "Cohen–Coon open-loop tuning for a first-order-plus-dead-time process",
            limitationDescription:
                "Classic quarter-amplitude settings are intended as initial values, not guaranteed final tuning. The implemented validity guard limits θ/τ to one or less."
        )
    }
}
