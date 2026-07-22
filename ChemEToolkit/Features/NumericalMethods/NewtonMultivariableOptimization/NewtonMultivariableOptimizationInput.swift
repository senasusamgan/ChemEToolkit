import Foundation
enum NewtonMultivariableOptimizationObjective: String, CaseIterable, Equatable, Sendable { case quadratic, coupledQuartic }
struct NewtonMultivariableOptimizationInput: Equatable, Sendable { let objective:NewtonMultivariableOptimizationObjective; let initialPoint:[Double]; let tolerance:Double; let maximumIterations:Int
 init(objective:NewtonMultivariableOptimizationObjective, initialPoint:[Double], tolerance:Double=1e-10, maximumIterations:Int=100) { self.objective=objective;self.initialPoint=initialPoint;self.tolerance=tolerance;self.maximumIterations=maximumIterations }
}
