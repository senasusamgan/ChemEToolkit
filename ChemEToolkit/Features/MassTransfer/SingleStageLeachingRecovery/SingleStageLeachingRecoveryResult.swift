struct SingleStageLeachingRecoveryResult:
    Equatable,
    Sendable {

    let equilibriumSoluteRatio: Double

    let retainedSolventFlowRate: Double
    let overflowSolventFlowRate: Double

    let soluteRecoveredInOverflow: Double
    let soluteRetainedWithUnderflow: Double
    let soluteRecoveryFraction: Double

    let overflowSolutionMassFlowRate: Double
    let underflowTotalMassFlowRate: Double

    let soluteBalanceResidual: Double
    let modelName: String
    let limitationDescription: String
}
