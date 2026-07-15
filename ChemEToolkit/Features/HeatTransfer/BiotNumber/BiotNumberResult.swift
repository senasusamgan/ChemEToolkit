import Foundation

struct BiotNumberResult:
    Equatable,
    Sendable {

    let biotNumber: Double
    let internalConductionScale: Double
    let externalConvectionCoefficient: Double

    /// Common engineering criterion: Bi < 0.1.
    let lumpedCapacitanceUsuallyValid: Bool
}
