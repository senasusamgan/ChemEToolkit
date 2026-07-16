struct TemperatureProcessDynamicsResult:
    Equatable,
    Sendable {

    let thermalCapacitance: Double
    let flowHeatCapacityRate:
        Double
    let heatTransferConductance:
        Double

    let processTimeConstant: Double
    let finalSteadyTemperature:
        Double
    let temperatureAtEvaluationTime:
        Double

    let flowHeatRateAtEvaluation:
        Double
    let environmentHeatRateAtEvaluation:
        Double
    let netHeatRateAtEvaluation:
        Double

    let fractionOfFinalChange:
        Double

    let modelName: String
    let limitationDescription: String
}
