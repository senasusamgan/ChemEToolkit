struct ReactionPerformanceBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            ReactionPerformanceBalanceInput
    ) throws
        -> ReactionPerformanceBalanceResult {

        let values = [
            input.reactantFeedAmount,
            input.reactantOutletAmount,
            input.desiredProductAmount,
            input.undesiredProductAmount
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReactionPerformanceBalanceError
                .nonFiniteInput
        }

        guard input.reactantFeedAmount > 0 else {
            throw ReactionPerformanceBalanceError
                .nonPositiveReactantFeed
        }

        guard
            input.reactantOutletAmount >= 0,
            input.desiredProductAmount >= 0,
            input.undesiredProductAmount >= 0
        else {
            throw ReactionPerformanceBalanceError
                .negativeAmount
        }

        guard
            input.reactantOutletAmount
            <= input.reactantFeedAmount
        else {
            throw ReactionPerformanceBalanceError
                .outletExceedsFeed
        }

        let consumed =
            input.reactantFeedAmount
            - input.reactantOutletAmount

        let totalProducts =
            input.desiredProductAmount
            + input.undesiredProductAmount

        let tolerance =
            max(
                1e-12,
                consumed * 1e-12
            )

        guard totalProducts <= consumed + tolerance else {
            throw ReactionPerformanceBalanceError
                .productExceedsReactantConsumption
        }

        let conversion =
            consumed
            / input.reactantFeedAmount

        let yieldOnFeed =
            input.desiredProductAmount
            / input.reactantFeedAmount

        let yieldOnReacted =
            consumed > 0
            ? input.desiredProductAmount
                / consumed
            : 0

        let selectivity =
            input.undesiredProductAmount > 0
            ? input.desiredProductAmount
                / input.undesiredProductAmount
            : (
                input.desiredProductAmount > 0
                ? Double.infinity
                : 0
            )

        let desiredDistribution =
            totalProducts > 0
            ? input.desiredProductAmount
                / totalProducts
            : 0

        let finiteOutputs = [
            consumed,
            conversion,
            yieldOnFeed,
            yieldOnReacted,
            desiredDistribution
        ]

        guard
            finiteOutputs.allSatisfy(\.isFinite),
            consumed >= 0,
            conversion >= 0,
            conversion <= 1,
            yieldOnFeed >= 0,
            yieldOnReacted >= 0,
            yieldOnReacted <= 1 + 1e-12,
            desiredDistribution >= 0,
            desiredDistribution <= 1,
            selectivity.isFinite
                || selectivity == Double.infinity
        else {
            throw ReactionPerformanceBalanceError
                .numericalFailure
        }

        return .init(
            reactantConsumedAmount:
                consumed,
            conversionFraction:
                conversion,
            desiredYieldOnFeed:
                yieldOnFeed,
            desiredYieldOnReactedBasis:
                min(1, yieldOnReacted),
            desiredToUndesiredSelectivity:
                selectivity,
            desiredProductDistributionFraction:
                desiredDistribution,
            modelName:
                "One-to-one-basis conversion, yield and selectivity analysis",
            limitationDescription:
                "Product amounts are assumed to be on an equivalent one mole of reactant consumed per mole of product basis. Apply stoichiometric normalization before using other reaction stoichiometries."
        )
    }
}
