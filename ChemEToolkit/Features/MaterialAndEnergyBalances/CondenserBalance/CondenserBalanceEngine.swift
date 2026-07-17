struct CondenserBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            CondenserBalanceInput
    ) throws
        -> CondenserBalanceResult {

        let values = [
            input.vaporFeedMassFlow,
            input.condensableMassFraction,
            input.condensableCondensationFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CondenserBalanceError
                .nonFiniteInput
        }

        guard input.vaporFeedMassFlow > 0 else {
            throw CondenserBalanceError
                .nonPositiveFeedFlow
        }

        let fractions = [
            input.condensableMassFraction,
            input.condensableCondensationFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw CondenserBalanceError
                .fractionOutsideRange
        }

        let condensableFeed =
            input.vaporFeedMassFlow
            * input.condensableMassFraction

        let noncondensableFeed =
            input.vaporFeedMassFlow
            - condensableFeed

        let condensate =
            condensableFeed
            * input.condensableCondensationFraction

        let uncondensedCondensable =
            condensableFeed
            - condensate

        let ventGas =
            noncondensableFeed
            + uncondensedCondensable

        let ventCondensableFraction =
            ventGas > 0
            ? uncondensedCondensable
                / ventGas
            : 0

        let overallCondensation =
            condensate
            / input.vaporFeedMassFlow

        let outputs = [
            condensableFeed,
            noncondensableFeed,
            condensate,
            uncondensedCondensable,
            ventGas,
            ventCondensableFraction,
            overallCondensation
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            ventCondensableFraction <= 1,
            overallCondensation <= 1
        else {
            throw CondenserBalanceError
                .numericalFailure
        }

        return .init(
            feedCondensableFlow:
                condensableFeed,
            feedNoncondensableFlow:
                noncondensableFeed,
            condensateLiquidFlow:
                condensate,
            uncondensedVaporFlow:
                uncondensedCondensable,
            ventGasFlow:
                ventGas,
            ventCondensableMassFraction:
                ventCondensableFraction,
            overallCondensationFraction:
                overallCondensation,
            modelName:
                "Partial condenser condensable/noncondensable balance",
            limitationDescription:
                "Assumes only the designated condensable species forms liquid, all noncondensables remain in the vent and condensate contains no noncondensable material."
        )
    }
}
