struct StandardGasFlowConverterInput:
    Equatable,
    Sendable {

    let actualVolumetricFlowRate:
        Double
    let actualAbsolutePressure:
        Double
    let actualTemperatureKelvin:
        Double

    let standardAbsolutePressure:
        Double
    let standardTemperatureKelvin:
        Double
}
