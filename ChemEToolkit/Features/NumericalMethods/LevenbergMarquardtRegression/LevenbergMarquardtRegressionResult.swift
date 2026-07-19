struct LevenbergMarquardtRegressionResult: Equatable, Sendable {
    let parameters: [Double]
    let predictions: [Double]
    let sumSquaredErrors: Double
    let iterations: Int
}
