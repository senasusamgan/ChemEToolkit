import Foundation

enum ModuleID:
    String,
    CaseIterable,
    Codable,
    Hashable,
    Identifiable {
    
    case planeWallConduction
    case convectionHeatTransfer
    case compositeWallConduction
    case cylindricalWallConduction

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
    case tankDrainTime
    case openChannelFlow
    case froudeNumber
    case criticalDepth
    case dragForce
    case particleSettling
    case venturiMeter
    case orificeMeter
    


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
