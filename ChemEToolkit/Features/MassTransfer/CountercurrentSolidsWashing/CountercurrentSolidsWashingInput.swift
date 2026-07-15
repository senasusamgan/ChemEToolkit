struct CountercurrentSolidsWashingInput:
    Equatable,
    Sendable {

    let insolubleSolidFlowRate: Double
    let retainedSolventPerInsolubleSolid: Double
    let freshWashSolventFlowRate: Double

    let feedUnderflowSoluteRatio: Double
    let freshWashSoluteRatio: Double

    let numberOfIdealStages: Double
}
