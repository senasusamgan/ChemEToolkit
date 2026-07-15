struct SingleStageLeachingRecoveryInput:
    Equatable,
    Sendable {

    let insolubleSolidFlowRate: Double
    let solubleSoluteFlowRate: Double
    let pureSolventFlowRate: Double
    let retainedSolventPerInsolubleSolid: Double
}
