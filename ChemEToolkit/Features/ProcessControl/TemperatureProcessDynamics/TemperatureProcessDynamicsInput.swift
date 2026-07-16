struct TemperatureProcessDynamicsInput:
    Equatable,
    Sendable {

    let liquidVolume: Double
    let liquidDensity: Double
    let specificHeatCapacity:
        Double

    let volumetricFlowRate: Double
    let overallHeatTransferConductance:
        Double

    let inletTemperature: Double
    let environmentTemperature:
        Double
    let initialTemperature: Double

    let evaluationTime: Double
}
