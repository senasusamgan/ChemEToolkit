struct StrippingMinimumGasRateResult: Equatable, Sendable {
    let minimumGasFlow: Double
    let designGasFlow: Double
    let pinchGasComposition: Double
    let soluteStrippedFlow: Double
    let gasToLiquidRatio: Double
    let modelName: String
    let limitationDescription: String
}
