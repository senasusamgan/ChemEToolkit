struct AdiabaticBatchReactorInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double

    let preExponentialFactor: Double
    let activationEnergy: Double

    let initialTemperature: Double
    let adiabaticTemperatureRise:
        Double

    let targetConversion: Double
}
