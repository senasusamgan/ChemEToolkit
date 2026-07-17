struct FlammabilityMixtureLimitsResult:
    Equatable,
    Sendable {

    let combustibleFractionSum:
        Double

    let normalizedComponent1Fraction:
        Double
    let normalizedComponent2Fraction:
        Double
    let normalizedComponent3Fraction:
        Double

    let mixtureLowerFlammabilityLimit:
        Double
    let mixtureUpperFlammabilityLimit:
        Double
    let flammableRangeWidth:
        Double

    let dominantFuelComponent:
        String

    let modelName: String
    let limitationDescription: String
}
