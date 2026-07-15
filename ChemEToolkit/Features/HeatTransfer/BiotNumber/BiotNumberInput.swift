import Foundation

struct BiotNumberInput:
    Equatable,
    Sendable {

    let heatTransferCoefficient: Double
    let characteristicLength: Double
    let solidThermalConductivity: Double
}
