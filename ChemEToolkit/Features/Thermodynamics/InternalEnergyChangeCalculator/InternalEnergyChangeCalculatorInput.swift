struct InternalEnergyChangeCalculatorInput:
    Equatable,
    Sendable {

    let mass: Double
    let specificHeatAtConstantVolume:
        Double
    let initialTemperature: Double
    let finalTemperature: Double
}
