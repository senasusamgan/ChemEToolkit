struct SingleStageLiquidLiquidExtractionInput:
    Equatable,
    Sendable {

    let raffinateCarrierFlowRate: Double
    let solventCarrierFlowRate: Double
    let feedSoluteRatio: Double
    let enteringSolventSoluteRatio: Double
    let distributionCoefficient: Double
}
