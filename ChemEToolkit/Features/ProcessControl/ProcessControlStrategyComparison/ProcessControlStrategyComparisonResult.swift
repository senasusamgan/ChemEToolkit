struct ProcessControlStrategyComparisonResult: Equatable, Sendable {
    let pidScore: Double
    let feedforwardScore: Double
    let cascadeScore: Double
    let mpcScore: Double
    let recommendedStrategy: String
    let secondChoiceStrategy: String
    let recommendationReason: String
    let scoreSeparation: Double
    let decisionConfidence: String
    let modelName: String
    let limitationDescription: String
}
