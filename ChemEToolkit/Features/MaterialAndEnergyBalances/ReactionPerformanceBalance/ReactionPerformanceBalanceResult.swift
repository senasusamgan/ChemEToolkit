struct ReactionPerformanceBalanceResult:
    Equatable,
    Sendable {

    let reactantConsumedAmount:
        Double
    let conversionFraction: Double

    let desiredYieldOnFeed:
        Double
    let desiredYieldOnReactedBasis:
        Double

    let desiredToUndesiredSelectivity:
        Double
    let desiredProductDistributionFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
