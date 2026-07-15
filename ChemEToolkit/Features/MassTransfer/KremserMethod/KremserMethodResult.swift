struct KremserMethodResult: Equatable, Sendable {
    let continuousIdealStageCount: Double
    let requiredWholeStageCount: Int
    let achievedOutletSoluteRatio: Double
    let targetRemovalFraction: Double
    let achievedRemovalFraction: Double
    let achievedRemainingFraction: Double
    let factorDescription: String
    let limitingCaseDescription: String
    let modelName: String
}
