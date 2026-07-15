struct RelativeVolatilityBinaryVLEResult: Equatable, Sendable {
    let liquidMoleFraction: Double
    let vaporMoleFraction: Double
    let equilibriumGap: Double
    let vaporEnrichmentFactor: Double
    let interpretation: String
    let modelName: String
}
