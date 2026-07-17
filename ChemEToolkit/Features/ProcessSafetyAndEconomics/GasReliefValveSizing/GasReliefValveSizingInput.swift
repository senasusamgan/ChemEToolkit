struct GasReliefValveSizingInput:
    Equatable,
    Sendable {

    let requiredMassFlowRate:
        Double
    let upstreamAbsolutePressure:
        Double
    let backAbsolutePressure:
        Double
    let relievingTemperature:
        Double

    let molecularWeight:
        Double
    let heatCapacityRatio:
        Double
    let dischargeCoefficient:
        Double
}
