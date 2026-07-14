struct DifferentialPressureFlowInput:
    Equatable,
    Sendable {

    let meterType:
        DifferentialPressureMeterType

    let fluidDensity: Double
    let upstreamDiameter: Double
    let restrictionDiameter: Double
    let pressureDifference: Double
    let dischargeCoefficient: Double
}
