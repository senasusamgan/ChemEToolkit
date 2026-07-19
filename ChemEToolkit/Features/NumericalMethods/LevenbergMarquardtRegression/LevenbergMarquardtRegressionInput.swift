enum LevenbergMarquardtRegressionModel: String, CaseIterable, Equatable, Sendable { case exponential, saturation }
struct LevenbergMarquardtRegressionInput: Equatable, Sendable {
    let xValues: [Double]
    let yValues: [Double]
    let model: LevenbergMarquardtRegressionModel
    let initialParameters: [Double]
    let initialDamping: Double
    let tolerance: Double
    let maximumIterations: Int
    init(xValues: [Double], yValues: [Double], model: LevenbergMarquardtRegressionModel, initialParameters: [Double], initialDamping: Double = 1e-3, tolerance: Double = 1e-10, maximumIterations: Int = 200) {
        self.xValues = xValues; self.yValues = yValues; self.model = model; self.initialParameters = initialParameters
        self.initialDamping = initialDamping; self.tolerance = tolerance; self.maximumIterations = maximumIterations
    }
}
