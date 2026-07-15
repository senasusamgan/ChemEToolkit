import Foundation

struct CriticalRadiusOfInsulationInput:
    Equatable,
    Sendable {

    let insulationThermalConductivity: Double
    let externalHeatTransferCoefficient: Double

    let innerRadius: Double
    let outerRadius: Double
    let cylinderLength: Double

    let innerSurfaceTemperature: Double
    let ambientTemperature: Double
}
