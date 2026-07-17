struct IsothermalIdealGasProcessInput:
    Equatable,
    Sendable {

    let amountKilomoles: Double
    let temperatureKelvin: Double
    let initialAbsolutePressure:
        Double
    let finalAbsolutePressure:
        Double
}
