struct HeatExchangeCSTRInput: Equatable, Sendable {
    let inletConcentrationA: Double
    let inletVolumetricFlowRate: Double
    let preExponentialFactor: Double
    let activationEnergy: Double
    let inletTemperature: Double
    let adiabaticTemperatureRise: Double
    let coolantTemperature: Double
    let heatRemovalNumber: Double
    let targetConversion: Double
}
