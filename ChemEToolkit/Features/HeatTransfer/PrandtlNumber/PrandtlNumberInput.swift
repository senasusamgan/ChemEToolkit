import Foundation

struct PrandtlNumberInput:
    Equatable,
    Sendable {

    let dynamicViscosity: Double
    let specificHeatCapacity: Double
    let thermalConductivity: Double
}
