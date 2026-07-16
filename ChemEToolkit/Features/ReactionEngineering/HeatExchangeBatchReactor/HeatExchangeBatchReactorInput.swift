struct HeatExchangeBatchReactorInput: Equatable, Sendable {
    let initialConcentrationA: Double
    let preExponentialFactor: Double
    let activationEnergy: Double
    let initialTemperature: Double
    let adiabaticTemperatureRise: Double
    let coolantTemperature: Double
    let heatRemovalCoefficient: Double
    let targetConversion: Double
    let maximumIntegrationTime: Double
}
