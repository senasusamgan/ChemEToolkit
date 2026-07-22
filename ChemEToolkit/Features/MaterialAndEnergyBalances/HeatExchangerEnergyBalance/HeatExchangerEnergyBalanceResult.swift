struct HeatExchangerEnergyBalanceResult:
    Equatable,
    Sendable {

    let heatDuty: Double
    let coldOutletTemperature:
        Double

    let hotCapacityRate: Double
    let coldCapacityRate: Double
    let minimumCapacityRate:
        Double

    let maximumPossibleDuty:
        Double
    let effectiveness: Double
    let coldTemperatureRise:
        Double

    let modelName: String
    let limitationDescription: String
}
