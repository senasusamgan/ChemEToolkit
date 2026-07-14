import Foundation

enum ConvectionHeatFlowDirection:
    Equatable,
    Sendable {

    case surfaceToFluid
    case fluidToSurface
    case equilibrium

    var description: String {
        switch self {
        case .surfaceToFluid:
            return "Surface → Fluid"

        case .fluidToSurface:
            return "Fluid → Surface"

        case .equilibrium:
            return "No net heat transfer"
        }
    }
}

struct ConvectionHeatTransferResult:
    Equatable,
    Sendable {

    /// Signed heat-transfer rate, W.
    ///
    /// Positive: surface to fluid.
    /// Negative: fluid to surface.
    let heatTransferRate: Double

    /// Absolute heat-transfer rate, W.
    let heatTransferRateMagnitude: Double

    /// Signed heat flux, W/m².
    let heatFlux: Double

    /// Convection resistance, K/W.
    let thermalResistance: Double

    /// Surface temperature minus fluid temperature.
    let temperatureDifference: Double

    let direction: ConvectionHeatFlowDirection
}
