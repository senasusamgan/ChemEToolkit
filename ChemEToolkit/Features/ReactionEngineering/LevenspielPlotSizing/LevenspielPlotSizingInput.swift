struct LevenspielPlotSizingInput:
    Equatable,
    Sendable {

    let inletMolarFlowRateA: Double

    let initialConversion: Double
    let finalConversion: Double

    let inverseRateAtInitialConversion:
        Double
    let inverseRateAtMidpointConversion:
        Double
    let inverseRateAtFinalConversion:
        Double
}
