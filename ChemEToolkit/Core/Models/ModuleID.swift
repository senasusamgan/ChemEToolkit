import Foundation

enum ModuleID: String, CaseIterable, Codable, Hashable, Identifiable {
    case unitConverter
    case idealGas
    case solutionConcentration
    case massBalance
    case reactorDesign
    case reactorComparison
    case numericalIntegration
    case numericalInterpolation
    case numericalDifferentiation
    case rootFinding
    case linearSystems
    case odeSolver
    case curveFitting
    
    var id: String {
        rawValue
    }
}
