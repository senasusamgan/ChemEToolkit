struct StreamSplitterBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            StreamSplitterBalanceInput
    ) throws
        -> StreamSplitterBalanceResult {

        let values = [
            input.feedMassFlow,
            input.product1SplitFraction,
            input.feedComponentMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw StreamSplitterBalanceError
                .nonFiniteInput
        }

        guard input.feedMassFlow >= 0 else {
            throw StreamSplitterBalanceError
                .negativeFeedFlow
        }

        let fractions = [
            input.product1SplitFraction,
            input.feedComponentMassFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw StreamSplitterBalanceError
                .fractionOutsideRange
        }

        let product1Flow =
            input.feedMassFlow
            * input.product1SplitFraction

        let product2Flow =
            input.feedMassFlow
            - product1Flow

        let product1Component =
            product1Flow
            * input.feedComponentMassFraction

        let product2Component =
            product2Flow
            * input.feedComponentMassFraction

        let product1Other =
            product1Flow
            - product1Component

        let product2Other =
            product2Flow
            - product2Component

        let outputs = [
            product1Flow,
            product2Flow,
            product1Component,
            product2Component,
            product1Other,
            product2Other
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= 0 })
        else {
            throw StreamSplitterBalanceError
                .numericalFailure
        }

        return .init(
            product1MassFlow:
                product1Flow,
            product2MassFlow:
                product2Flow,
            product1ComponentFlow:
                product1Component,
            product2ComponentFlow:
                product2Component,
            product1OtherComponentFlow:
                product1Other,
            product2OtherComponentFlow:
                product2Other,
            modelName:
                "Ideal nonseparating stream splitter",
            limitationDescription:
                "An ideal splitter preserves feed composition in both outlet streams. Use a separator balance when outlet compositions differ."
        )
    }
}
