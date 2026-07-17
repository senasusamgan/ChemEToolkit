struct ClausiusClapeyronEstimatorInput:
    Equatable,
    Sendable {

    let referenceTemperatureKelvin:
        Double
    let referencePressure: Double
    let targetTemperatureKelvin:
        Double
    let molarLatentHeat:
        Double
}
