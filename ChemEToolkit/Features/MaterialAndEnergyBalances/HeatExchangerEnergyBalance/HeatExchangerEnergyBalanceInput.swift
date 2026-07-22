struct HeatExchangerEnergyBalanceInput:
    Equatable,
    Sendable {

    let hotMassFlow: Double
    let hotHeatCapacity: Double
    let hotInletTemperature:
        Double
    let hotOutletTemperature:
        Double

    let coldMassFlow: Double
    let coldHeatCapacity: Double
    let coldInletTemperature:
        Double
}
