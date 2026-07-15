import Foundation

struct BoilingHeatTransferInput:
    Equatable,
    Sendable {

    let surfaceTemperature: Double
    let saturationTemperature: Double
    let boilingHeatTransferCoefficient: Double
    let surfaceArea: Double
}
