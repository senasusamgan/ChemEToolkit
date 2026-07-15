import Foundation

struct ThermalResistanceBranchResult:
    Equatable,
    Sendable {

    let branchNumber: Int
    let resistance: Double
    let heatTransferRate: Double
    let temperatureDrop: Double
}

struct ThermalResistanceNetworkResult:
    Equatable,
    Sendable {

    let arrangement:
        ThermalResistanceArrangement

    let equivalentResistance: Double
    let totalHeatTransferRate: Double
    let temperatureDifference: Double

    let branchResults:
        [ThermalResistanceBranchResult]
}
