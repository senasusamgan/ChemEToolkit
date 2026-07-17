struct HumidifierWaterBalanceResult:
    Equatable,
    Sendable {

    let inletWaterVaporFlow:
        Double
    let outletWaterVaporFlow:
        Double
    let waterAddedFlow: Double

    let inletHumidGasFlow:
        Double
    let outletHumidGasFlow:
        Double

    let outletWaterMassFraction:
        Double
    let humidGasFlowIncreaseFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
