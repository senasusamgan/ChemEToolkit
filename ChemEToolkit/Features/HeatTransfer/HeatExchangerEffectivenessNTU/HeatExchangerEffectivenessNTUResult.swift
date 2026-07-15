import Foundation

struct HeatExchangerEffectivenessNTUResult:
    Equatable,
    Sendable {

    let flowArrangement:
        HeatExchangerNTUArrangement

    let hotCapacityRate: Double
    let coldCapacityRate: Double

    let minimumCapacityRate: Double
    let maximumCapacityRate: Double

    let capacityRateRatio: Double
    let numberOfTransferUnits: Double

    let effectiveness: Double

    let maximumPossibleHeatTransferRate: Double
    let actualHeatTransferRate: Double

    let hotOutletTemperature: Double
    let coldOutletTemperature: Double
}
