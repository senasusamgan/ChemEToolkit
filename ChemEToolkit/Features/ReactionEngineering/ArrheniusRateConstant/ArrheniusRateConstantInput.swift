struct ArrheniusRateConstantInput:
    Equatable,
    Sendable {

    let preExponentialFactor: Double
    let activationEnergy: Double
    let temperature: Double
}
