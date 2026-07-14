import Foundation

struct PlaneWallConductionResult:
    Equatable,
    Sendable {

    /// Total heat-transfer rate through the wall, W.
    let heatTransferRate: Double

    /// Heat-transfer rate per unit area, W/m².
    let heatFlux: Double

    /// Conduction resistance of the wall, K/W.
    let thermalResistance: Double

    /// Temperature difference across the wall, K or °C.
    let temperatureDifference: Double
}
