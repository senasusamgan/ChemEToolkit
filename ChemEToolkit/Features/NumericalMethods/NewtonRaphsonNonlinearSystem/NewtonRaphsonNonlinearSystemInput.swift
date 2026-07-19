import Foundation

enum NewtonRaphsonNonlinearSystemSystem: String, CaseIterable, Equatable, Sendable {
    case circleAndLine
    case equilibriumBalance
}

struct NewtonRaphsonNonlinearSystemInput: Equatable, Sendable {
    let system: NewtonRaphsonNonlinearSystemSystem
    let parameter: Double
    let initialGuess: [Double]
    let tolerance: Double
    let maximumIterations: Int
    init(system: NewtonRaphsonNonlinearSystemSystem, parameter: Double = 0.16, initialGuess: [Double], tolerance: Double = 1e-10, maximumIterations: Int = 100) {
        self.system = system; self.parameter = parameter; self.initialGuess = initialGuess
        self.tolerance = tolerance; self.maximumIterations = maximumIterations
    }
}
