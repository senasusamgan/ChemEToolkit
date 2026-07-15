import Foundation

enum CombinedHeatFlowDirection:
    Equatable,
    Sendable {

    case surfaceToEnvironment
    case environmentToSurface
    case equilibrium

    var description: String {
        switch self {
        case .surfaceToEnvironment:
            return "Surface → Environment"

        case .environmentToSurface:
            return "Environment → Surface"

        case .equilibrium:
            return "No net heat transfer"
        }
    }
}

enum CombinedHeatTransferDominantMode:
    Equatable,
    Sendable {

    case convection
    case radiation
    case equal

    var description: String {
        switch self {
        case .convection:
            return "Convection"

        case .radiation:
            return "Radiation"

        case .equal:
            return "Equal contribution"
        }
    }
}

struct CombinedConvectionRadiationResult:
    Equatable,
    Sendable {

    let convectionHeatTransferRate: Double
    let radiationHeatTransferRate: Double
    let totalHeatTransferRate: Double
    let totalHeatTransferMagnitude: Double

    let convectionHeatFlux: Double
    let radiationHeatFlux: Double
    let totalHeatFlux: Double

    let convectionTemperatureDifference: Double
    let radiationTemperatureDifference: Double

    let effectiveRadiationCoefficient: Double

    let direction: CombinedHeatFlowDirection
    let dominantMode: CombinedHeatTransferDominantMode

    /// True when convection and radiation act in
    /// opposite directions.
    let modesOppose: Bool
}
