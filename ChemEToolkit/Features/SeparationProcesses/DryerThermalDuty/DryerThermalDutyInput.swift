struct DryerThermalDutyInput:
    Equatable,
    Sendable {

    let drySolidMassFlow:
        Double
    let inletMoistureDryBasis:
        Double
    let outletMoistureDryBasis:
        Double
    let latentHeatOfVaporization:
        Double
    let sensibleHeatDuty:
        Double
    let thermalEfficiency:
        Double
}
