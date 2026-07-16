struct BypassFractionEstimatorResult:
    Equatable,
    Sendable {

    let bypassFraction: Double
    let reactorPathFraction: Double

    let bypassFlowRate: Double
    let reactorPathFlowRate: Double

    let concentrationRatio: Double
    let interpretationDescription:
        String

    let modelName: String
    let limitationDescription: String
}
