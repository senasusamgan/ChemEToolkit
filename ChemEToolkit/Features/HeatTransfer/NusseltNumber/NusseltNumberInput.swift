import Foundation

struct NusseltNumberInput:
    Equatable,
    Sendable {

    let heatTransferCoefficient: Double
    let characteristicLength: Double
    let fluidThermalConductivity: Double
}
