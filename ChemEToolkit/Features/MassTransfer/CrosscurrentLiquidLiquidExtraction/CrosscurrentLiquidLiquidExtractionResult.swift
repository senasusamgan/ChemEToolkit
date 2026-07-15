struct CrosscurrentLiquidLiquidExtractionResult:
    Equatable,
    Sendable {

    let numberOfStages: Int
    let solventFlowPerStage: Double
    let extractionFactorPerStage: Double
    let finalRaffinateSoluteRatio: Double
    let finalStageExtractSoluteRatio: Double
    let soluteRemainingFraction: Double
    let overallRemovalFraction: Double
    let totalTransferRate: Double
    let raffinateRatiosByStage: [Double]
    let extractRatiosByStage: [Double]
    let modelName: String
}
