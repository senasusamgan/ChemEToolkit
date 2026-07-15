struct CountercurrentLiquidLiquidExtractionInput:
    Equatable,
    Sendable {

    let raffinateCarrierFlowRate: Double
    let solventCarrierFlowRate: Double
    let distributionCoefficient: Double
    let feedSoluteRatio: Double
    let targetRaffinateSoluteRatio: Double
    let enteringSolventSoluteRatio: Double
}
