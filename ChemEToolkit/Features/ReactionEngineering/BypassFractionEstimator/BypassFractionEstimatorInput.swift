struct BypassFractionEstimatorInput:
    Equatable,
    Sendable {

    let inletTracerConcentration:
        Double
    let immediateOutletTracerConcentration:
        Double
    let totalVolumetricFlowRate:
        Double
}
