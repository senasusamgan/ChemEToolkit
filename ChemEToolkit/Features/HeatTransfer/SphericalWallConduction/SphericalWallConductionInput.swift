import Foundation

struct SphericalWallConductionInput:
    Equatable,
    Sendable {

    let thermalConductivity: Double
    let innerRadius: Double
    let outerRadius: Double

    let innerSurfaceTemperature: Double
    let outerSurfaceTemperature: Double
}
