import Foundation
enum NelderMeadOptimizationObjective:String,CaseIterable,Equatable,Sendable{case quadratic,rosenbrock}
struct NelderMeadOptimizationInput:Equatable,Sendable{let objective:NelderMeadOptimizationObjective;let initialPoint:[Double];let initialStep:Double;let tolerance:Double;let maximumIterations:Int
 init(objective:NelderMeadOptimizationObjective,initialPoint:[Double],initialStep:Double=1,tolerance:Double=1e-9,maximumIterations:Int=1000){self.objective=objective;self.initialPoint=initialPoint;self.initialStep=initialStep;self.tolerance=tolerance;self.maximumIterations=maximumIterations}}
