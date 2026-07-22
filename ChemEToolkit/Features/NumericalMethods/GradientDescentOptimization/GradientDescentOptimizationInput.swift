import Foundation
enum GradientDescentOptimizationObjective: String, CaseIterable, Equatable, Sendable { case quadratic, rosenbrock }
struct GradientDescentOptimizationInput: Equatable, Sendable { let objective:GradientDescentOptimizationObjective; let initialPoint:[Double]; let initialStep:Double; let tolerance:Double; let maximumIterations:Int
 init(objective:GradientDescentOptimizationObjective, initialPoint:[Double], initialStep:Double=0.1, tolerance:Double=1e-8, maximumIterations:Int=10000) { self.objective=objective; self.initialPoint=initialPoint; self.initialStep=initialStep; self.tolerance=tolerance; self.maximumIterations=maximumIterations }
}
