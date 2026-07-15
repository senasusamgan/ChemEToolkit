struct ConversionYieldSelectivityResult:
    Equatable,
    Sendable {

    let reactantMolesConsumed: Double
    let reactantConversionFraction: Double

    let desiredReactantEquivalent:
        Double
    let undesiredReactantEquivalent:
        Double
    let accountedReactantConsumption:
        Double
    let unaccountedReactantConsumption:
        Double

    let desiredYieldOnFeedFraction:
        Double
    let desiredYieldOnConsumedFraction:
        Double
    let desiredSelectivityFraction:
        Double
    let desiredToUndesiredSelectivityRatio:
        Double

    let accountingClosureFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
