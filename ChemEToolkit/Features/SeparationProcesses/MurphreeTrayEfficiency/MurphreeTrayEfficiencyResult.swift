struct MurphreeTrayEfficiencyResult: Equatable, Sendable {
    let continuousActualStageCount: Double
    let requiredActualTrays: Int
    let activeTrayHeight: Double
    let designTraySectionHeight: Double
    let stagePenalty: Double
    let modelName: String
    let limitationDescription: String
}
