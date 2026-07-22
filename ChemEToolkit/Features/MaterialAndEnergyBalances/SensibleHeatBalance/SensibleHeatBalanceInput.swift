struct SensibleHeatBalanceInput:
    Equatable,
    Sendable {

    let massFlowRate: Double
    let specificHeatCapacity:
        Double
    let inletTemperature:
        Double
    let outletTemperature:
        Double
}
