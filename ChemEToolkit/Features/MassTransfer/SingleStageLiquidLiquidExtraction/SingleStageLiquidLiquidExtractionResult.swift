struct SingleStageLiquidLiquidExtractionResult:
    Equatable,
    Sendable {

    let raffinateOutletSoluteRatio: Double
    let extractOutletSoluteRatio: Double
    let extractionFactor: Double
    let signedTransferRateToExtract: Double
    let transferRateMagnitude: Double
    let raffinateRemovalFraction: Double
    let soluteBalanceResidual: Double
    let directionDescription: String
    let modelName: String
}
