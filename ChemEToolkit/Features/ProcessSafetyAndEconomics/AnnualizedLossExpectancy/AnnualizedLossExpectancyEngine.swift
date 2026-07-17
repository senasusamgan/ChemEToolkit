struct AnnualizedLossExpectancyEngine:
    Sendable {

    func calculate(
        _ input:
            AnnualizedLossExpectancyInput
    ) throws
        -> AnnualizedLossExpectancyResult {

        let values = [
            input.eventFrequencyPerYear,
            input.assetDamageCost,
            input.businessInterruptionCost,
            input.environmentalRemediationCost,
            input.injuryAndLiabilityCost,
            input.insuranceRecoveryFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AnnualizedLossExpectancyError
                .nonFiniteInput
        }

        guard input.eventFrequencyPerYear >= 0 else {
            throw AnnualizedLossExpectancyError
                .negativeFrequency
        }

        let costs = [
            input.assetDamageCost,
            input.businessInterruptionCost,
            input.environmentalRemediationCost,
            input.injuryAndLiabilityCost
        ]

        guard costs.allSatisfy({ $0 >= 0 }) else {
            throw AnnualizedLossExpectancyError
                .negativeCost
        }

        guard
            input.insuranceRecoveryFraction >= 0,
            input.insuranceRecoveryFraction <= 1
        else {
            throw AnnualizedLossExpectancyError
                .insuranceFractionOutsideRange
        }

        let grossLoss = costs.reduce(0, +)

        let insuranceRecovery =
            grossLoss
            * input.insuranceRecoveryFraction

        let retainedLoss =
            grossLoss
            - insuranceRecovery

        let annualizedGross =
            grossLoss
            * input.eventFrequencyPerYear

        let annualizedRetained =
            retainedLoss
            * input.eventFrequencyPerYear

        let retainedFraction =
            grossLoss > 0
            ? retainedLoss / grossLoss
            : 0

        let categories = [
            ("Asset damage", input.assetDamageCost),
            ("Business interruption", input.businessInterruptionCost),
            (
                "Environmental remediation",
                input.environmentalRemediationCost
            ),
            (
                "Injury and liability",
                input.injuryAndLiabilityCost
            )
        ]

        let dominant =
            categories.max {
                $0.1 < $1.1
            }?.0
            ?? "None"

        let outputs = [
            grossLoss,
            insuranceRecovery,
            retainedLoss,
            annualizedGross,
            annualizedRetained,
            retainedFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            grossLoss >= 0,
            retainedLoss >= 0,
            annualizedGross >= 0,
            annualizedRetained >= 0,
            retainedFraction >= 0,
            retainedFraction <= 1
        else {
            throw AnnualizedLossExpectancyError
                .numericalFailure
        }

        return .init(
            grossSingleEventLoss:
                grossLoss,
            insuranceRecovery:
                insuranceRecovery,
            retainedSingleEventLoss:
                retainedLoss,
            annualizedGrossLoss:
                annualizedGross,
            annualizedRetainedLoss:
                annualizedRetained,
            retainedLossFraction:
                retainedFraction,
            dominantLossCategory:
                dominant,
            modelName:
                "Frequency × consequence annualized-loss screening",
            limitationDescription:
                "Uses one average event frequency and deterministic consequence estimate. Tail risk, escalation, deductibles, policy limits, indirect reputation effects and correlated events are excluded."
        )
    }
}
