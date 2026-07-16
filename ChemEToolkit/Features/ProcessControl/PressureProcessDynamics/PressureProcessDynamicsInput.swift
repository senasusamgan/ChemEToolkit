struct PressureProcessDynamicsInput: Equatable, Sendable {
    let vesselVolume: Double
    let gasTemperature: Double
    let pressureFlowResistance: Double

    let initialPressure: Double
    let molarInflowStepChange: Double

    let evaluationTime: Double
    let maximumAllowablePressure: Double
}
