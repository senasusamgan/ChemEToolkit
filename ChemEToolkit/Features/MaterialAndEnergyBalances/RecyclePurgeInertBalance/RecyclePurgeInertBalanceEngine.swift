struct RecyclePurgeInertBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            RecyclePurgeInertBalanceInput
    ) throws
        -> RecyclePurgeInertBalanceResult {

        let values = [
            input.freshFeedMassFlow,
            input.freshFeedInertMassFraction,
            input.singlePassReactantConversion,
            input.purgeFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RecyclePurgeInertBalanceError
                .nonFiniteInput
        }

        guard input.freshFeedMassFlow > 0 else {
            throw RecyclePurgeInertBalanceError
                .nonPositiveFreshFeed
        }

        let fractions = [
            input.freshFeedInertMassFraction,
            input.singlePassReactantConversion
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw RecyclePurgeInertBalanceError
                .fractionOutsideRange
        }

        guard
            input.purgeFraction > 0,
            input.purgeFraction <= 1
        else {
            throw RecyclePurgeInertBalanceError
                .invalidPurgeFraction
        }

        let freshInert =
            input.freshFeedMassFlow
            * input.freshFeedInertMassFraction

        let freshReactant =
            input.freshFeedMassFlow
            - freshInert

        let recycleMultiplier =
            (
                1
                - input.purgeFraction
            )
            * (
                1
                - input.singlePassReactantConversion
            )

        let denominator =
            1 - recycleMultiplier

        guard denominator > 1e-14 else {
            throw RecyclePurgeInertBalanceError
                .singularRecycleSystem
        }

        let recycleReactant =
            recycleMultiplier
            * freshReactant
            / denominator

        let recycleInert =
            (
                1
                - input.purgeFraction
            )
            * freshInert
            / input.purgeFraction

        let totalRecycle =
            recycleReactant
            + recycleInert

        let reactorFeed =
            input.freshFeedMassFlow
            + totalRecycle

        let reactorFeedInertFraction =
            (
                freshInert
                + recycleInert
            )
            / reactorFeed

        let reactorReactantFeed =
            freshReactant
            + recycleReactant

        let unreactedAfterReactor =
            (
                1
                - input.singlePassReactantConversion
            )
            * reactorReactantFeed

        let totalGasAfterSeparation =
            unreactedAfterReactor
            + freshInert
            + recycleInert

        let purgeFlow =
            input.purgeFraction
            * totalGasAfterSeparation

        let purgeReactant =
            input.purgeFraction
            * unreactedAfterReactor

        let purgeInert =
            input.purgeFraction
            * (
                freshInert
                + recycleInert
            )

        let overallConversion =
            freshReactant > 0
            ? 1
                - purgeReactant
                / freshReactant
            : 0

        let outputs = [
            freshReactant,
            freshInert,
            recycleReactant,
            recycleInert,
            totalRecycle,
            reactorFeed,
            reactorFeedInertFraction,
            purgeFlow,
            purgeReactant,
            purgeInert,
            overallConversion
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= 0 }),
            reactorFeedInertFraction <= 1,
            overallConversion <= 1 + 1e-12
        else {
            throw RecyclePurgeInertBalanceError
                .numericalFailure
        }

        return .init(
            freshReactantFlow:
                freshReactant,
            freshInertFlow:
                freshInert,
            recycleReactantFlow:
                recycleReactant,
            recycleInertFlow:
                recycleInert,
            totalRecycleFlow:
                totalRecycle,
            reactorFeedFlow:
                reactorFeed,
            reactorFeedInertMassFraction:
                reactorFeedInertFraction,
            purgeFlow:
                purgeFlow,
            purgeReactantFlow:
                purgeReactant,
            purgeInertFlow:
                purgeInert,
            overallReactantConversion:
                min(
                    1,
                    overallConversion
                ),
            modelName:
                "Steady recycle–purge reactant and inert balance",
            limitationDescription:
                "Assumes one reactant, one inert, complete product removal after the reactor, identical purge and recycle compositions and constant single-pass conversion."
        )
    }
}
