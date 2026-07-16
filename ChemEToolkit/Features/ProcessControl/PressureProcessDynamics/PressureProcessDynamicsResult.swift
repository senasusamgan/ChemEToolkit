struct PressureProcessDynamicsResult: Equatable, Sendable {
    let gasCapacitance: Double
    let processTimeConstant: Double
    let processGain: Double

    let pressureAtEvaluationTime: Double
    let finalSteadyPressure: Double
    let initialPressureRate: Double
    let fractionOfFinalChange: Double

    let overpressureRisk: Bool
    let availablePressureMargin: Double

    let modelName: String
    let limitationDescription: String
}
