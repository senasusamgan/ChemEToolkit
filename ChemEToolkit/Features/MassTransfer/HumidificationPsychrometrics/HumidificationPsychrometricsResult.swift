struct HumidificationPsychrometricsResult:
    Equatable,
    Sendable {

    let saturationVaporPressureKPa: Double
    let inletVaporPressureKPa: Double
    let outletVaporPressureKPa: Double

    let inletHumidityRatio: Double
    let outletHumidityRatio: Double
    let saturationHumidityRatio: Double

    let signedWaterTransferRate: Double
    let waterTransferMagnitude: Double

    let inletDewPointCelsius: Double?
    let outletDewPointCelsius: Double?

    let inletHumidEnthalpy: Double
    let outletHumidEnthalpy: Double
    let signedIsothermalHeatDuty: Double

    let directionDescription: String
    let modelName: String
}
