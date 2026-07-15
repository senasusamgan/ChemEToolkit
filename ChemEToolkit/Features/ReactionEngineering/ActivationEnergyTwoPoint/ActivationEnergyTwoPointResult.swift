struct ActivationEnergyTwoPointResult:
    Equatable,
    Sendable {

    let activationEnergy: Double
    let activationEnergyKilojoulesPerMole:
        Double

    let preExponentialFactorFromPointOne:
        Double
    let preExponentialFactorFromPointTwo:
        Double
    let averagePreExponentialFactor:
        Double

    let naturalLogRateRatio: Double
    let reciprocalTemperatureDifference:
        Double
    let relativePreExponentialMismatch:
        Double

    let trendDescription: String
    let modelName: String
}
