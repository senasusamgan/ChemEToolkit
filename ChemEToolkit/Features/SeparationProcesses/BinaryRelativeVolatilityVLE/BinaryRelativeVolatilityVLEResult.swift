struct BinaryRelativeVolatilityVLEResult:
    Equatable,
    Sendable {

    let vaporMoleFraction: Double
    let equilibriumDenominator:
        Double
    let vaporLiquidEnrichment:
        Double
    let equilibriumSeparation:
        Double
    let heavyComponentLiquidFraction:
        Double
    let heavyComponentVaporFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
