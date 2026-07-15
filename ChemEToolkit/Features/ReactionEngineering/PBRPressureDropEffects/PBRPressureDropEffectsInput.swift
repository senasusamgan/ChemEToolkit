struct PBRPressureDropEffectsInput:
    Equatable,
    Sendable {

    let catalystWeight: Double

    let inletMolarFlowRateA: Double
    let inletConcentrationA: Double
    let massSpecificFirstOrderRateConstant:
        Double

    let pressureDropParameter: Double
    let inletPressure: Double
}
