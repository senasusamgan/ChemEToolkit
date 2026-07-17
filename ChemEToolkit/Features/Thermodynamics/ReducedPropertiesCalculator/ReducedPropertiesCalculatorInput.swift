struct ReducedPropertiesCalculatorInput:
    Equatable,
    Sendable {

    let temperatureKelvin: Double
    let criticalTemperatureKelvin:
        Double
    let absolutePressure: Double
    let criticalPressure: Double
}
