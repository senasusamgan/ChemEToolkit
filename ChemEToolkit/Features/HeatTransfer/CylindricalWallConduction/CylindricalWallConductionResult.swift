import Foundation

struct CylindricalWallConductionResult:
    Equatable,
    Sendable {

    /// Radial heat-transfer rate, W.
    let heatTransferRate: Double

    /// Cylindrical conduction resistance, K/W.
    let thermalResistance: Double

    /// Temperature difference between surfaces.
    let temperatureDifference: Double

    /// Heat flux at the inner cylindrical surface, W/m².
    let innerSurfaceHeatFlux: Double

    /// Heat flux at the outer cylindrical surface, W/m².
    let outerSurfaceHeatFlux: Double

    /// Inner cylindrical surface area, m².
    let innerSurfaceArea: Double

    /// Outer cylindrical surface area, m².
    let outerSurfaceArea: Double
}
