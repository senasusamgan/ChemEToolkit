import Foundation

struct CylindricalWallConductionInput:
    Equatable,
    Sendable {

    let thermalConductivity: Double
    let innerRadius: Double
    let outerRadius: Double
    let cylinderLength: Double
    let innerSurfaceTemperature: Double
    let outerSurfaceTemperature: Double
}
