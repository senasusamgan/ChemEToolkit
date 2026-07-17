struct EnthalpyChangeCalculatorInput:
    Equatable,
    Sendable {

    let mass: Double
    let specificHeatAtConstantPressure:
        Double
    let initialTemperature: Double
    let finalTemperature: Double
}
