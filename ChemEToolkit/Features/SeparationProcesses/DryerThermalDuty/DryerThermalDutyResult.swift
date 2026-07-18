struct DryerThermalDutyResult:
    Equatable,
    Sendable {

    let evaporatedWaterFlow:
        Double
    let latentHeatDuty:
        Double
    let usefulHeatDuty:
        Double
    let requiredHeatInput:
        Double
    let heatLoss:
        Double

    let modelName: String
    let limitationDescription:
        String
}
