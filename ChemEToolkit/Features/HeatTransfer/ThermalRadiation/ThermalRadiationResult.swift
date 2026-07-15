import Foundation

enum RadiationHeatFlowDirection:
    Equatable,
    Sendable {

    case surfaceToSurroundings
    case surroundingsToSurface
    case equilibrium

    var description: String {
        switch self {
        case .surfaceToSurroundings:
            return "Surface → Surroundings"

        case .surroundingsToSurface:
            return "Surroundings → Surface"

        case .equilibrium:
            return "No net radiation"
        }
    }
}

struct ThermalRadiationResult:
    Equatable,
    Sendable {

    let surfaceTemperatureKelvin: Double
    let surroundingsTemperatureKelvin: Double

    /// Surface temperature minus surroundings temperature.
    let temperatureDifference: Double

    /// Signed net radiation heat-transfer rate, W.
    let heatTransferRate: Double

    /// Absolute radiation heat-transfer rate, W.
    let heatTransferRateMagnitude: Double

    /// Signed radiation heat flux, W/m².
    let heatFlux: Double

    /// Linearized radiation coefficient, W/(m²·K).
    let effectiveRadiationCoefficient: Double

    let direction: RadiationHeatFlowDirection
}
