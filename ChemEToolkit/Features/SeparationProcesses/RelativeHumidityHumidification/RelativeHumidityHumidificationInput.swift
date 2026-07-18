struct RelativeHumidityHumidificationInput:
    Equatable,
    Sendable {

    let dryAirMassFlow:
        Double
    let dryBulbTemperatureC:
        Double
    let totalPressureKPa:
        Double
    let inletRelativeHumidityPercent:
        Double
    let outletRelativeHumidityPercent:
        Double
}
