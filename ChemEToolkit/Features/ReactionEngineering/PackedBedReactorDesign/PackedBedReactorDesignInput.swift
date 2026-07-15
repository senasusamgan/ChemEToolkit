struct PackedBedReactorDesignInput:
    Equatable,
    Sendable {

    let inletConcentrationA: Double
    let inletVolumetricFlowRate: Double

    let massSpecificFirstOrderRateConstant:
        Double
    let targetConversion: Double
}
