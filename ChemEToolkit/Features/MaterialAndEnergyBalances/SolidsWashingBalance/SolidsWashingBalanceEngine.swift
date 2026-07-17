struct SolidsWashingBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            SolidsWashingBalanceInput
    ) throws
        -> SolidsWashingBalanceResult {

        let values = [
            input.initialRetainedSolutionMass,
            input.initialSoluteMassFraction,
            input.washSolventMass,
            input.finalRetainedSolutionMass
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SolidsWashingBalanceError
                .nonFiniteInput
        }

        guard
            input.initialRetainedSolutionMass > 0
        else {
            throw SolidsWashingBalanceError
                .nonPositiveInitialSolution
        }

        guard
            input.initialSoluteMassFraction >= 0,
            input.initialSoluteMassFraction <= 1
        else {
            throw SolidsWashingBalanceError
                .fractionOutsideRange
        }

        guard input.washSolventMass >= 0 else {
            throw SolidsWashingBalanceError
                .negativeWashSolvent
        }

        let totalMixedLiquid =
            input.initialRetainedSolutionMass
            + input.washSolventMass

        guard
            input.finalRetainedSolutionMass >= 0,
            input.finalRetainedSolutionMass
                <= totalMixedLiquid
        else {
            throw SolidsWashingBalanceError
                .invalidFinalRetainedMass
        }

        let initialSolute =
            input.initialRetainedSolutionMass
            * input.initialSoluteMassFraction

        let mixedFraction =
            initialSolute
            / totalMixedLiquid

        let finalRetainedSolute =
            input.finalRetainedSolutionMass
            * mixedFraction

        let effluentMass =
            totalMixedLiquid
            - input.finalRetainedSolutionMass

        let removedSolute =
            initialSolute
            - finalRetainedSolute

        let removalFraction =
            initialSolute > 0
            ? removedSolute / initialSolute
            : 0

        let outputs = [
            initialSolute,
            totalMixedLiquid,
            mixedFraction,
            finalRetainedSolute,
            effluentMass,
            removedSolute,
            removalFraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            mixedFraction <= 1,
            removalFraction <= 1 + 1e-12
        else {
            throw SolidsWashingBalanceError
                .numericalFailure
        }

        return .init(
            initialSoluteMass:
                initialSolute,
            totalMixedLiquidMass:
                totalMixedLiquid,
            mixedLiquidSoluteMassFraction:
                mixedFraction,
            finalRetainedSoluteMass:
                max(0, finalRetainedSolute),
            washEffluentMass:
                effluentMass,
            soluteRemovedMass:
                max(0, removedSolute),
            soluteRemovalFraction:
                min(1, max(0, removalFraction)),
            modelName:
                "Single ideal-mixing solids-washing stage",
            limitationDescription:
                "Assumes pure wash solvent, complete mixing of retained liquid and wash solvent, followed by drainage to the entered final liquid holdup."
        )
    }
}
