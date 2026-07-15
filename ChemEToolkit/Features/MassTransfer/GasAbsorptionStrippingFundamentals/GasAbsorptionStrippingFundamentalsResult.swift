struct GasAbsorptionStrippingFundamentalsResult: Equatable, Sendable {
    let liquidOutletSoluteRatio: Double
    let absorptionFactor: Double
    let strippingFactor: Double
    let signedTransferRateToLiquid: Double
    let transferRateMagnitude: Double
    let soluteRemovalFraction: Double
    let limitingCarrierFlowRate: Double
    let actualToMinimumFlowRatio: Double
    let pinchDrivingForce: Double
    let limitingFlowDescription: String
    let directionDescription: String
    let modelName: String
}
