struct CrystallizationYieldMotherLiquorEngine:
    Sendable {

    private let stateTolerance =
        1.0e-10

    func calculate(
        _ input:
            CrystallizationYieldMotherLiquorInput
    ) throws
        -> CrystallizationYieldMotherLiquorResult {

        let values = [
            input.feedSolutionMass,
            input.feedSoluteMassFraction,
            input.evaporatedSolventMass,
            input.finalSolubilityRatio,
            input.crystalSoluteMassFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                CrystallizationYieldMotherLiquorError
                    .nonFiniteInput
        }

        guard input.feedSolutionMass > 0 else {
            throw
                CrystallizationYieldMotherLiquorError
                    .nonPositiveFeedMass
        }

        guard
            input.feedSoluteMassFraction > 0,
            input.feedSoluteMassFraction < 1
        else {
            throw
                CrystallizationYieldMotherLiquorError
                    .feedCompositionOutOfRange
        }

        guard input.evaporatedSolventMass >= 0 else {
            throw
                CrystallizationYieldMotherLiquorError
                    .negativeEvaporation
        }

        guard input.finalSolubilityRatio > 0 else {
            throw
                CrystallizationYieldMotherLiquorError
                    .nonPositiveSolubility
        }

        guard
            input.crystalSoluteMassFraction
            > 0,
            input.crystalSoluteMassFraction
            <= 1
        else {
            throw
                CrystallizationYieldMotherLiquorError
                    .crystalCompositionOutOfRange
        }

        let initialSolute =
            input.feedSolutionMass
            * input.feedSoluteMassFraction

        let initialSolvent =
            input.feedSolutionMass
            * (
                1
                - input.feedSoluteMassFraction
            )

        guard
            input.evaporatedSolventMass
            < initialSolvent
        else {
            throw
                CrystallizationYieldMotherLiquorError
                    .evaporationRemovesAllSolvent
        }

        let remainingSolvent =
            initialSolvent
            - input.evaporatedSolventMass

        let dissolvedRatioBeforeCrystallization =
            initialSolute
            / remainingSolvent

        let supersaturationRatio =
            dissolvedRatioBeforeCrystallization
            / input.finalSolubilityRatio

        let phaseState:
            CrystallizationPhaseState

        let crystalMass: Double
        let crystalSoluteMass: Double
        let crystalSolventMass: Double

        let motherLiquorSolventMass: Double
        let motherLiquorSoluteMass: Double
        let motherLiquorSoluteRatio: Double

        let stateDescription: String

        if supersaturationRatio
            < 1 - stateTolerance {

            phaseState = .undersaturated

            crystalMass = 0
            crystalSoluteMass = 0
            crystalSolventMass = 0

            motherLiquorSolventMass =
                remainingSolvent

            motherLiquorSoluteMass =
                initialSolute

            motherLiquorSoluteRatio =
                dissolvedRatioBeforeCrystallization

            stateDescription =
                "The concentrated solution remains below the final solubility limit; no crystals form."

        } else if abs(
            supersaturationRatio - 1
        ) <= stateTolerance {

            phaseState = .saturated

            crystalMass = 0
            crystalSoluteMass = 0
            crystalSolventMass = 0

            motherLiquorSolventMass =
                remainingSolvent

            motherLiquorSoluteMass =
                initialSolute

            motherLiquorSoluteRatio =
                input.finalSolubilityRatio

            stateDescription =
                "The solution reaches saturation without a positive crystal yield."

        } else {
            phaseState = .crystalsFormed

            let denominator =
                input.crystalSoluteMassFraction
                - input.finalSolubilityRatio
                * (
                    1
                    - input.crystalSoluteMassFraction
                )

            guard denominator > 0 else {
                throw
                    CrystallizationYieldMotherLiquorError
                        .incompatibleCrystalComposition
            }

            crystalMass =
                (
                    initialSolute
                    - input.finalSolubilityRatio
                    * remainingSolvent
                )
                / denominator

            crystalSoluteMass =
                input.crystalSoluteMassFraction
                * crystalMass

            crystalSolventMass =
                (
                    1
                    - input.crystalSoluteMassFraction
                )
                * crystalMass

            motherLiquorSolventMass =
                remainingSolvent
                - crystalSolventMass

            motherLiquorSoluteMass =
                input.finalSolubilityRatio
                * motherLiquorSolventMass

            motherLiquorSoluteRatio =
                input.finalSolubilityRatio

            stateDescription =
                "The final solution is supersaturated, so crystals and saturated mother liquor are formed."
        }

        let motherLiquorTotalMass =
            motherLiquorSolventMass
            + motherLiquorSoluteMass

        let recoveryFraction =
            crystalSoluteMass
            / initialSolute

        let crystalYieldOnFeed =
            crystalMass
            / input.feedSolutionMass

        let finalMass =
            crystalMass
            + motherLiquorTotalMass
            + input.evaporatedSolventMass

        let massResidual =
            input.feedSolutionMass
            - finalMass

        let results = [
            initialSolute,
            initialSolvent,
            remainingSolvent,
            supersaturationRatio,
            crystalMass,
            crystalSoluteMass,
            crystalSolventMass,
            motherLiquorSolventMass,
            motherLiquorSoluteMass,
            motherLiquorTotalMass,
            motherLiquorSoluteRatio,
            recoveryFraction,
            crystalYieldOnFeed,
            massResidual
        ]

        guard
            results.allSatisfy(\.isFinite),
            initialSolute > 0,
            initialSolvent > 0,
            remainingSolvent > 0,
            supersaturationRatio > 0,
            crystalMass >= 0,
            crystalSoluteMass >= 0,
            crystalSolventMass >= 0,
            motherLiquorSolventMass >= 0,
            motherLiquorSoluteMass >= 0,
            motherLiquorTotalMass > 0,
            motherLiquorSoluteRatio >= 0,
            recoveryFraction >= 0,
            recoveryFraction <= 1,
            crystalYieldOnFeed >= 0
        else {
            throw
                CrystallizationYieldMotherLiquorError
                    .numericalFailure
        }

        return
            CrystallizationYieldMotherLiquorResult(
                phaseState: phaseState,
                initialSoluteMass:
                    initialSolute,
                initialSolventMass:
                    initialSolvent,
                remainingSolventAfterEvaporation:
                    remainingSolvent,
                supersaturationRatio:
                    supersaturationRatio,
                crystalMass:
                    crystalMass,
                crystalSoluteMass:
                    crystalSoluteMass,
                crystalSolventMass:
                    crystalSolventMass,
                motherLiquorSolventMass:
                    motherLiquorSolventMass,
                motherLiquorSoluteMass:
                    motherLiquorSoluteMass,
                motherLiquorTotalMass:
                    motherLiquorTotalMass,
                motherLiquorSoluteRatio:
                    motherLiquorSoluteRatio,
                soluteRecoveryFraction:
                    recoveryFraction,
                crystalYieldOnFeed:
                    crystalYieldOnFeed,
                totalMassBalanceResidual:
                    massResidual,
                stateDescription:
                    stateDescription,
                modelName:
                    "Equilibrium evaporative/cooling crystallization mass balance"
            )
    }
}
