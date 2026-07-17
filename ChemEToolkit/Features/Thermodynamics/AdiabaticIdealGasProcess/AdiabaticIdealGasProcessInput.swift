struct AdiabaticIdealGasProcessInput:
    Equatable,
    Sendable {

    let initialTemperatureKelvin:
        Double
    let initialAbsolutePressure:
        Double
    let finalAbsolutePressure:
        Double
    let heatCapacityRatio: Double
    let specificGasConstant:
        Double
}
