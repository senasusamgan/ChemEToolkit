struct HumidificationPsychrometricsInput:
    Equatable,
    Sendable {

    let dryAirMassFlowRate: Double
    let dryBulbTemperatureCelsius: Double
    let totalPressureKPa: Double
    let inletRelativeHumidity: Double
    let outletRelativeHumidity: Double
}
