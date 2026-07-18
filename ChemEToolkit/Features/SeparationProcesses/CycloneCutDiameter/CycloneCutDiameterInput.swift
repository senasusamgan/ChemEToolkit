struct CycloneCutDiameterInput: Equatable, Sendable {
    let gasViscosity: Double
    let inletWidth: Double
    let effectiveTurns: Double
    let particleDensity: Double
    let gasDensity: Double
    let inletVelocity: Double
}
