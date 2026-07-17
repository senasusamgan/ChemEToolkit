struct FlammabilityMixtureLimitsInput:
    Equatable,
    Sendable {

    let component1Fraction: Double
    let component1LowerLimit:
        Double
    let component1UpperLimit:
        Double

    let component2Fraction: Double
    let component2LowerLimit:
        Double
    let component2UpperLimit:
        Double

    let component3Fraction: Double
    let component3LowerLimit:
        Double
    let component3UpperLimit:
        Double
}
