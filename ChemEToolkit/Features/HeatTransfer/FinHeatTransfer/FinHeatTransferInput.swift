import Foundation

struct FinHeatTransferInput:
    Equatable,
    Sendable {

    let heatTransferCoefficient: Double
    let thermalConductivity: Double

    let finLength: Double
    let finWidth: Double
    let finThickness: Double

    let baseTemperature: Double
    let ambientTemperature: Double
}
