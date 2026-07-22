struct DensitySpecificGravityResult:
    Equatable,
    Sendable {

    let density: Double
    let specificGravity: Double
    let specificVolume: Double

    let modelName: String
    let limitationDescription: String
}
