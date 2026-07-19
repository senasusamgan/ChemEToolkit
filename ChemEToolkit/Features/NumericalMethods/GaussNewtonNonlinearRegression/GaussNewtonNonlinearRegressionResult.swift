struct GaussNewtonNonlinearRegressionResult: Equatable, Sendable {
    let parameterA: Double
    let parameterB: Double
    let sumSquaredError: Double
    let rootMeanSquaredError: Double
    let iterationCount: Double
    let modelName: String
    let limitationDescription: String
}
