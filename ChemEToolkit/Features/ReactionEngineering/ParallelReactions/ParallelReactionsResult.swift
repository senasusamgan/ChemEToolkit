struct ParallelReactionsResult:
    Equatable,
    Sendable {

    let finalConcentrationA: Double
    let desiredProductConcentration:
        Double
    let undesiredProductConcentration:
        Double

    let reactantConversionFraction:
        Double
    let desiredYieldOnFeedFraction:
        Double
    let desiredYieldOnConsumedFraction:
        Double

    let desiredSelectivityFraction:
        Double
    let desiredToUndesiredSelectivityRatio:
        Double

    let totalFirstOrderRateConstant:
        Double
    let initialTotalDisappearanceRate:
        Double
    let finalTotalDisappearanceRate:
        Double

    let modelName: String
    let limitationDescription: String
}
