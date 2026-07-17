struct EvaporatorBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            EvaporatorBalanceInput
    ) throws
        -> EvaporatorBalanceResult {

        let values = [
            input.feedMassFlow,
            input.feedSoluteMassFraction,
            input.productSoluteMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EvaporatorBalanceError
                .nonFiniteInput
        }

        guard input.feedMassFlow > 0 else {
            throw EvaporatorBalanceError
                .nonPositiveFeedFlow
        }

        let fractions = [
            input.feedSoluteMassFraction,
            input.productSoluteMassFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw EvaporatorBalanceError
                .fractionOutsideRange
        }

        guard
            input.productSoluteMassFraction > 0,
            input.productSoluteMassFraction
                >= input.feedSoluteMassFraction
        else {
            throw EvaporatorBalanceError
                .invalidProductConcentration
        }

        let feedSolute =
            input.feedMassFlow
            * input.feedSoluteMassFraction

        let feedSolvent =
            input.feedMassFlow
            - feedSolute

        let productFlow =
            feedSolute
            / input.productSoluteMassFraction

        let productSolvent =
            productFlow
            - feedSolute

        let evaporatedSolvent =
            input.feedMassFlow
            - productFlow

        let concentrationFactor =
            input.feedSoluteMassFraction > 0
            ? input.productSoluteMassFraction
                / input.feedSoluteMassFraction
            : 0

        let solventRemovalFraction =
            feedSolvent > 0
            ? evaporatedSolvent
                / feedSolvent
            : 0

        let outputs = [
            feedSolute,
            feedSolvent,
            productFlow,
            productSolvent,
            evaporatedSolvent,
            concentrationFactor,
            solventRemovalFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            solventRemovalFraction <= 1 + 1e-12
        else {
            throw EvaporatorBalanceError
                .numericalFailure
        }

        return .init(
            feedSoluteFlow:
                feedSolute,
            feedSolventFlow:
                feedSolvent,
            concentratedProductFlow:
                max(
                    0,
                    productFlow
                ),
            productSolventFlow:
                max(
                    0,
                    productSolvent
                ),
            evaporatedSolventFlow:
                max(
                    0,
                    evaporatedSolvent
                ),
            concentrationFactor:
                concentrationFactor,
            solventRemovalFraction:
                min(
                    1,
                    max(
                        0,
                        solventRemovalFraction
                    )
                ),
            modelName:
                "Single-effect nonvolatile-solute evaporator mass balance",
            limitationDescription:
                "Assumes the solute is completely nonvolatile, the vapor contains only solvent and no entrainment or accumulation occurs."
        )
    }
}
