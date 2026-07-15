import Foundation

struct LumpedCapacitanceInput:
    Equatable,
    Sendable {

    let mass: Double
    let specificHeatCapacity: Double

    let heatTransferCoefficient: Double
    let surfaceArea: Double

    let initialTemperature: Double
    let ambientTemperature: Double
    let elapsedTime: Double

    let thermalConductivity: Double
    let characteristicLength: Double
}
