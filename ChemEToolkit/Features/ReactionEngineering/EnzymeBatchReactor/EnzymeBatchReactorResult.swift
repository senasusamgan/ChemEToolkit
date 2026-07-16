struct EnzymeBatchReactorResult: Equatable, Sendable {
    let timeToTargetConversion: Double
    let finalSubstrateConcentration: Double
    let productConcentration: Double
    let productMoles: Double
    let initialReactionRate: Double
    let finalReactionRate: Double
    let averageProductFormationRate: Double
    let modelName: String
    let limitationDescription: String
}
