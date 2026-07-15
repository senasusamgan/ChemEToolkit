struct McCabeThieleMethodResult: Equatable, Sendable {
    let continuousTheoreticalStageCount: Double
    let requiredWholeStageCount: Int
    let feedStageNumber: Int
    let minimumRefluxRatio: Double
    let actualToMinimumRefluxRatio: Double
    let rectifyingSlope: Double
    let strippingSlope: Double
    let feedIntersectionLiquidMoleFraction: Double
    let feedIntersectionVaporMoleFraction: Double
    let finalStageFraction: Double
    let stageLiquidCompositions: [Double]
    let countingConvention: String
    let modelName: String
}
