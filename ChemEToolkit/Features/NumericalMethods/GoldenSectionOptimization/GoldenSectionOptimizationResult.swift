struct GoldenSectionOptimizationResult: Equatable, Sendable {
    let minimizingX: Double
    let minimumValue: Double
    let finalIntervalWidth: Double
    let iterationCount: Double
    let analyticalStationaryPoint: Double
    let modelName: String
    let limitationDescription: String
}
