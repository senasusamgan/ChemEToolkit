struct ShootingMethodBoundaryValueResult: Equatable, Sendable {
    let requiredInitialSlope: Double
    let achievedFinalY: Double
    let boundaryResidual: Double
    let iterationCount: Double
    let integrationSteps: Double
    let modelName: String
    let limitationDescription: String
}
