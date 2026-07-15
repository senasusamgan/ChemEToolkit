struct AdiabaticPFRInput:
    Equatable,
    Sendable {

    let inletConcentrationA: Double
    let inletVolumetricFlowRate: Double

    let preExponentialFactor: Double
    let activationEnergy: Double

    let inletTemperature: Double
    let adiabaticTemperatureRise:
        Double

    let targetConversion: Double
}
