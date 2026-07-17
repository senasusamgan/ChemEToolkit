struct BinarySeparatorBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            BinarySeparatorBalanceInput
    ) throws
        -> BinarySeparatorBalanceResult {

        let values = [
            input.feedMassFlow,
            input.feedComponentMassFraction,
            input.product1MassFlow,
            input.product1ComponentMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BinarySeparatorBalanceError
                .nonFiniteInput
        }

        guard input.feedMassFlow > 0 else {
            throw BinarySeparatorBalanceError
                .nonPositiveFeedFlow
        }

        guard
            input.product1MassFlow >= 0,
            input.product1MassFlow
                < input.feedMassFlow
        else {
            throw BinarySeparatorBalanceError
                .invalidProductFlow
        }

        let fractions = [
            input.feedComponentMassFraction,
            input.product1ComponentMassFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw BinarySeparatorBalanceError
                .fractionOutsideRange
        }

        let product2Flow =
            input.feedMassFlow
            - input.product1MassFlow

        let feedComponent =
            input.feedMassFlow
            * input.feedComponentMassFraction

        let product1Component =
            input.product1MassFlow
            * input.product1ComponentMassFraction

        let product2Component =
            feedComponent
            - product1Component

        let tolerance =
            max(
                1e-12,
                feedComponent * 1e-12
            )

        guard
            product2Component >= -tolerance,
            product2Component
                <= product2Flow + tolerance
        else {
            throw BinarySeparatorBalanceError
                .infeasibleComponentBalance
        }

        let correctedProduct2Component =
            min(
                product2Flow,
                max(
                    0,
                    product2Component
                )
            )

        let product2Fraction =
            correctedProduct2Component
            / product2Flow

        let recovery1 =
            feedComponent > 0
            ? product1Component
                / feedComponent
            : 0

        let recovery2 =
            feedComponent > 0
            ? correctedProduct2Component
                / feedComponent
            : 0

        let outputs = [
            product2Flow,
            feedComponent,
            product1Component,
            correctedProduct2Component,
            product2Fraction,
            recovery1,
            recovery2
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            product2Fraction >= 0,
            product2Fraction <= 1,
            recovery1 >= 0,
            recovery2 >= 0
        else {
            throw BinarySeparatorBalanceError
                .numericalFailure
        }

        return .init(
            product2MassFlow:
                product2Flow,
            feedComponentFlow:
                feedComponent,
            product1ComponentFlow:
                product1Component,
            product2ComponentFlow:
                correctedProduct2Component,
            product2ComponentMassFraction:
                product2Fraction,
            componentRecoveryToProduct1:
                recovery1,
            componentRecoveryToProduct2:
                recovery2,
            modelName:
                "Binary steady separator total and component balance",
            limitationDescription:
                "Assumes two components, steady state, no reaction and no accumulation. Product 2 composition is solved from the entered Feed and Product 1 conditions."
        )
    }
}
