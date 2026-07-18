struct AbsorptionMinimumSolventRateResult: Equatable, Sendable {
    let minimumSolventFlow: Double
    let designSolventFlow: Double
    let pinchLiquidComposition: Double
    let soluteAbsorbedFlow: Double
    let liquidToGasRatio: Double
    let modelName: String
    let limitationDescription: String
}
