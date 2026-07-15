struct CountercurrentSolidsWashingResult:
    Equatable,
    Sendable {

    let numberOfIdealStages: Int

    let retainedSolventFlowRate: Double
    let overflowSolventFlowRate: Double
    let washingFactor: Double

    let productOverflowSoluteRatio: Double
    let finalUnderflowSoluteRatio: Double

    let initialSoluteWithUnderflow: Double
    let recoveredSoluteInOverflow: Double
    let residualSoluteWithWashedSolids: Double

    let soluteRemovalFraction: Double
    let soluteBalanceResidual: Double

    let stageSoluteRatios: [Double]

    let modelName: String
    let limitationDescription: String
}
