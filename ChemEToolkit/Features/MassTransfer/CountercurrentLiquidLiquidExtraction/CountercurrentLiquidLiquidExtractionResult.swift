struct CountercurrentLiquidLiquidExtractionResult:
    Equatable,
    Sendable {

    let extractionFactor: Double
    let continuousIdealStageCount: Double
    let requiredWholeStageCount: Int
    let equilibriumRaffinateLimit: Double
    let achievedRaffinateSoluteRatio: Double
    let solventOutletSoluteRatio: Double
    let targetRemovalFraction: Double
    let achievedRemovalFraction: Double
    let soluteTransferRate: Double
    let limitingCaseDescription: String
    let modelName: String
}
