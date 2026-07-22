struct SensibleHeatBalanceResult:
    Equatable,
    Sendable {

    let temperatureChange: Double
    let signedHeatDuty: Double
    let absoluteHeatDuty: Double
    let heatDutyPerUnitMass:
        Double
    let processDirection: String

    let modelName: String
    let limitationDescription: String
}
