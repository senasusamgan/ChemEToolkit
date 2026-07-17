struct ProcessControlStrategyComparisonInput: Equatable, Sendable {
    let deadTimeToTimeConstantRatio: Double
    let measurableDisturbanceFraction: Double
    let secondaryMeasurementQuality: Double
    let processInteractionLevel: Double
    let processModelConfidence: Double
    let operatingNonlinearity: Double
}
