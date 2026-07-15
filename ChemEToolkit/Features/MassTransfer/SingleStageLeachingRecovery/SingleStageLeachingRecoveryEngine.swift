struct SingleStageLeachingRecoveryEngine:
    Sendable {

    func calculate(
        _ input:
            SingleStageLeachingRecoveryInput
    ) throws
        -> SingleStageLeachingRecoveryResult {

        let values = [
            input.insolubleSolidFlowRate,
            input.solubleSoluteFlowRate,
            input.pureSolventFlowRate,
            input.retainedSolventPerInsolubleSolid
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                SingleStageLeachingRecoveryError
                    .nonFiniteInput
        }

        guard
            input.insolubleSolidFlowRate > 0,
            input.pureSolventFlowRate > 0,
            input.retainedSolventPerInsolubleSolid > 0
        else {
            throw
                SingleStageLeachingRecoveryError
                    .nonPositiveProperty
        }

        guard input.solubleSoluteFlowRate >= 0 else {
            throw
                SingleStageLeachingRecoveryError
                    .negativeSoluteFlow
        }

        let retainedSolvent =
            input.insolubleSolidFlowRate
            * input.retainedSolventPerInsolubleSolid

        guard
            input.pureSolventFlowRate
            > retainedSolvent
        else {
            throw
                SingleStageLeachingRecoveryError
                    .noOverflowSolution
        }

        let overflowSolvent =
            input.pureSolventFlowRate
            - retainedSolvent

        let equilibriumSoluteRatio =
            input.solubleSoluteFlowRate
            / input.pureSolventFlowRate

        let soluteRecovered =
            overflowSolvent
            * equilibriumSoluteRatio

        let soluteRetained =
            retainedSolvent
            * equilibriumSoluteRatio

        let recoveryFraction =
            input.solubleSoluteFlowRate > 0
            ? soluteRecovered
                / input.solubleSoluteFlowRate
            : 0

        let overflowSolutionMass =
            overflowSolvent
            + soluteRecovered

        let underflowTotalMass =
            input.insolubleSolidFlowRate
            + retainedSolvent
            + soluteRetained

        let residual =
            input.solubleSoluteFlowRate
            - soluteRecovered
            - soluteRetained

        let results = [
            retainedSolvent,
            overflowSolvent,
            equilibriumSoluteRatio,
            soluteRecovered,
            soluteRetained,
            recoveryFraction,
            overflowSolutionMass,
            underflowTotalMass,
            residual
        ]

        guard
            results.allSatisfy(\.isFinite),
            retainedSolvent > 0,
            overflowSolvent > 0,
            equilibriumSoluteRatio >= 0,
            soluteRecovered >= 0,
            soluteRetained >= 0,
            recoveryFraction >= 0,
            recoveryFraction <= 1
        else {
            throw
                SingleStageLeachingRecoveryError
                    .numericalFailure
        }

        return
            SingleStageLeachingRecoveryResult(
                equilibriumSoluteRatio:
                    equilibriumSoluteRatio,
                retainedSolventFlowRate:
                    retainedSolvent,
                overflowSolventFlowRate:
                    overflowSolvent,
                soluteRecoveredInOverflow:
                    soluteRecovered,
                soluteRetainedWithUnderflow:
                    soluteRetained,
                soluteRecoveryFraction:
                    recoveryFraction,
                overflowSolutionMassFlowRate:
                    overflowSolutionMass,
                underflowTotalMassFlowRate:
                    underflowTotalMass,
                soluteBalanceResidual:
                    residual,
                modelName:
                    "Ideal single-stage leaching on a solute-free-solvent ratio basis",
                limitationDescription:
                    "All soluble material is assumed to dissolve completely, and overflow and retained underflow solution leave with the same solute ratio."
            )
    }
}
