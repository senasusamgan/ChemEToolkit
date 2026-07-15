import Foundation

struct GrashofNumberInput:
    Equatable,
    Sendable {

    let gravitationalAcceleration: Double
    let thermalExpansionCoefficient: Double

    let surfaceTemperature: Double
    let fluidTemperature: Double

    let characteristicLength: Double
    let kinematicViscosity: Double
}
