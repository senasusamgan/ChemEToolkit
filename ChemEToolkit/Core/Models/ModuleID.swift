import Foundation

enum ModuleID:
    String,
    CaseIterable,
    Codable,
    Hashable,
    Identifiable {

    case unitConverter
    case idealGas
    case solutionConcentration
    case massBalance
    case reactorDesign
    case reactorComparison

    case reynoldsNumber
    case bernoulliEquation
    case flowRate
    case frictionFactor
    case pressureDrop
    case minorLosses
    case pumpPower
    case hydrostaticPressure
    case uTubeManometer

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
