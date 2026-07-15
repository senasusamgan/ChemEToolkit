struct CrosscurrentLiquidLiquidExtractionInput:
    Equatable,
    Sendable {

    let raffinateCarrierFlowRate: Double
    let totalFreshSolventFlowRate: Double
    let feedSoluteRatio: Double
    let freshSolventSoluteRatio: Double
    let distributionCoefficient: Double
    let numberOfStages: Double
}
