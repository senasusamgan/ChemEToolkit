struct InversePowerMethodEigenvalueResult: Equatable, Sendable {
    let nearestEigenvalue: Double
    let eigenvectorX: Double
    let eigenvectorY: Double
    let residualNorm: Double
    let iterationCount: Double
    let modelName: String
    let limitationDescription: String
}
