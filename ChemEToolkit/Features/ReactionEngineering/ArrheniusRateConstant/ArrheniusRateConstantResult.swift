struct ArrheniusRateConstantResult:
    Equatable,
    Sendable {

    let rateConstant: Double
    let exponentialFactor: Double
    let activationEnergyOverRT: Double
    let naturalLogRateConstant: Double
    let temperatureSensitivity: Double
    let temperatureForDoubleRateApproximation: Double

    let modelName: String
    let limitationDescription: String
}
