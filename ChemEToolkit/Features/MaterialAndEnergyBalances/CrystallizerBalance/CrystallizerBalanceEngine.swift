struct CrystallizerBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            CrystallizerBalanceInput
    ) throws
        -> CrystallizerBalanceResult {

        let values = [
            input.feedMassFlow,
            input.feedSoluteMassFraction,
            input.motherLiquorSoluteMassFraction,
            input.crystalSoluteMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CrystallizerBalanceError
                .nonFiniteInput
        }

        guard input.feedMassFlow > 0 else {
            throw CrystallizerBalanceError
                .nonPositiveFeedFlow
        }

        let fractions = [
            input.feedSoluteMassFraction,
            input.motherLiquorSoluteMassFraction,
            input.crystalSoluteMassFraction
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw CrystallizerBalanceError
                .fractionOutsideRange
        }

        guard
            input.crystalSoluteMassFraction
            > input.motherLiquorSoluteMassFraction
        else {
            throw CrystallizerBalanceError
                .invalidPhaseCompositions
        }

        guard
            input.feedSoluteMassFraction
                >= input.motherLiquorSoluteMassFraction,
            input.feedSoluteMassFraction
                <= input.crystalSoluteMassFraction
        else {
            throw CrystallizerBalanceError
                .infeasibleFeedComposition
        }

        let crystalFlow =
            input.feedMassFlow
            * (
                input.feedSoluteMassFraction
                - input.motherLiquorSoluteMassFraction
            )
            / (
                input.crystalSoluteMassFraction
                - input.motherLiquorSoluteMassFraction
            )

        let motherLiquorFlow =
            input.feedMassFlow
            - crystalFlow

        let feedSolute =
            input.feedMassFlow
            * input.feedSoluteMassFraction

        let crystalSolute =
            crystalFlow
            * input.crystalSoluteMassFraction

        let motherLiquorSolute =
            motherLiquorFlow
            * input.motherLiquorSoluteMassFraction

        let recovery =
            feedSolute > 0
            ? crystalSolute / feedSolute
            : 0

        let yield =
            crystalFlow
            / input.feedMassFlow

        let outputs = [
            crystalFlow,
            motherLiquorFlow,
            feedSolute,
            crystalSolute,
            motherLiquorSolute,
            recovery,
            yield
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            recovery <= 1 + 1e-12,
            yield <= 1 + 1e-12
        else {
            throw CrystallizerBalanceError
                .numericalFailure
        }

        return .init(
            crystalMassFlow:
                max(0, crystalFlow),
            motherLiquorMassFlow:
                max(0, motherLiquorFlow),
            feedSoluteFlow:
                feedSolute,
            crystalSoluteFlow:
                max(0, crystalSolute),
            motherLiquorSoluteFlow:
                max(0, motherLiquorSolute),
            soluteRecoveryToCrystals:
                min(1, max(0, recovery)),
            crystalYieldFromFeed:
                min(1, max(0, yield)),
            modelName:
                "Two-product crystallizer total and solute balance",
            limitationDescription:
                "Assumes steady state, two outlet phases, fixed phase compositions and no evaporation, reaction or entrainment."
        )
    }
}
