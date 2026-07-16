struct NonIsothermalCSTRSteadyStatesInput: Equatable, Sendable {
    let inletConcentrationA: Double
    let spaceTime: Double
    let preExponentialFactor: Double
    let activationEnergy: Double
    let inletTemperature: Double
    let adiabaticTemperatureRise: Double
    let coolantTemperature: Double
    let heatRemovalNumber: Double
}
