struct IsochoricIdealGasProcessInput:
    Equatable,
    Sendable {

    let mass: Double
    let specificHeatAtConstantVolume:
        Double
    let initialTemperatureKelvin:
        Double
    let finalTemperatureKelvin:
        Double
}
