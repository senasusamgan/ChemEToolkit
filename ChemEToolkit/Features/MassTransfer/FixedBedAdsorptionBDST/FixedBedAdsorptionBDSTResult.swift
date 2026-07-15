struct FixedBedAdsorptionBDSTResult:
    Equatable,
    Sendable {

    let breakthroughRatio: Double

    let minimumBedDepth: Double
    let serviceTimeToBreakthrough:
        Double
    let bedDepthSafetyMargin: Double

    let volumetricFlowRate: Double
    let bedVolume: Double
    let bedSaturationCapacity:
        Double

    let treatedFluidVolume: Double
    let nominalInfluentSoluteThroughput:
        Double
    let nominalCapacityUtilization:
        Double

    let modelName: String
    let limitationDescription: String
}
