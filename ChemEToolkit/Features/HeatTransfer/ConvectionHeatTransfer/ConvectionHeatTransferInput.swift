import Foundation

struct ConvectionHeatTransferInput:
    Equatable,
    Sendable {

    let heatTransferCoefficient: Double
    let area: Double
    let surfaceTemperature: Double
    let fluidTemperature: Double
}
