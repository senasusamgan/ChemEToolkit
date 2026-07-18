struct HydrocycloneSeparationNumberInput: Equatable, Sendable {
    let particleDiameter: Double
    let particleDensity: Double
    let liquidDensity: Double
    let liquidViscosity: Double
    let tangentialVelocity: Double
    let cycloneRadius: Double
}
