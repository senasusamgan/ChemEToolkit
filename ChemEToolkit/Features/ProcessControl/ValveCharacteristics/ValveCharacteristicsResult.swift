struct ValveCharacteristicsResult: Equatable, Sendable {
    let openingFraction: Double
    let relativeFlowCoefficient: Double
    let effectiveKv: Double
    let predictedLiquidFlow: Double
    let localRelativeSlope: Double
    let characteristicDescription: String
    let modelName: String
    let limitationDescription: String
}
