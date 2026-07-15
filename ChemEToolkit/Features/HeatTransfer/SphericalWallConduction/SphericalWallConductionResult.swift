import Foundation

struct SphericalWallConductionResult:
    Equatable,
    Sendable {

    let thermalResistance: Double
    let heatTransferRate: Double
    let temperatureDifference: Double

    let innerSurfaceArea: Double
    let outerSurfaceArea: Double

    let innerSurfaceHeatFlux: Double
    let outerSurfaceHeatFlux: Double
}
