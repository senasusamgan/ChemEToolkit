struct PowerMethodEigenvalueResult: Equatable, Sendable {
    let dominantEigenvalue: Double
    let eigenvectorX: Double
    let eigenvectorY: Double
    let residualNorm: Double
    let iterationCount: Double
    let modelName: String
    let limitationDescription: String
}
