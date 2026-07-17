struct IsobaricIdealGasProcessInput:
    Equatable,
    Sendable {

    let mass: Double
    let specificHeatAtConstantPressure:
        Double
    let specificGasConstant:
        Double
    let initialTemperatureKelvin:
        Double
    let finalTemperatureKelvin:
        Double
}
