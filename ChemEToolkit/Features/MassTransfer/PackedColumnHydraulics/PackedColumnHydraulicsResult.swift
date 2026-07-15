struct PackedColumnHydraulicsResult: Equatable, Sendable {
    let designGasVelocity: Double
    let columnCrossSectionalArea: Double
    let columnDiameter: Double
    let superficialLiquidVelocity: Double
    let fractionOfFlooding: Double
    let gasCapacityFactor: Double
    let modifiedParticleReynoldsNumber: Double
    let dryPressureDropPerLength: Double
    let totalDryPressureDrop: Double
    let designAssessment: String
    let modelName: String
    let limitationDescription: String
}
