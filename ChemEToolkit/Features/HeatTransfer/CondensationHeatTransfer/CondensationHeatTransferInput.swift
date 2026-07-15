import Foundation

struct CondensationHeatTransferInput:
    Equatable,
    Sendable {

    let saturationTemperature: Double
    let surfaceTemperature: Double
    let condensationHeatTransferCoefficient: Double
    let surfaceArea: Double
}
