struct SeriesParallelReactionsResult:
    Equatable,
    Sendable {

    let concentrationA: Double
    let desiredIntermediateB: Double
    let seriesProductC: Double
    let parallelByproductD: Double

    let conversionOfA: Double
    let desiredYieldOnFeed: Double
    let desiredFractionOfProducts:
        Double
    let desiredToUndesiredRatio:
        Double

    let timeOfMaximumB: Double
    let maximumConcentrationB: Double

    let totalPrimaryDisappearanceConstant:
        Double

    let modelName: String
    let limitationDescription: String
}
