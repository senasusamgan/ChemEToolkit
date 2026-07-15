import Foundation

struct CombinedConvectionRadiationInput:
    Equatable,
    Sendable {

    let heatTransferCoefficient: Double
    let emissivity: Double
    let area: Double

    let surfaceTemperature: Double
    let fluidTemperature: Double
    let surroundingsTemperature: Double
}
