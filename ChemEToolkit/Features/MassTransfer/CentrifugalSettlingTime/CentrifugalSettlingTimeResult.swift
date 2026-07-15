struct CentrifugalSettlingTimeResult:
    Equatable,
    Sendable {

    let angularVelocity: Double
    let radialResponseCoefficient:
        Double

    let innerRadialVelocity: Double
    let outerRadialVelocity: Double

    let migrationDistance: Double
    let migrationTime: Double

    let outerCentrifugalAcceleration:
        Double
    let outerRelativeCentrifugalForce:
        Double

    let outerParticleReynoldsNumber:
        Double
    let densityDifference: Double

    let modelName: String
    let limitationDescription: String
}
