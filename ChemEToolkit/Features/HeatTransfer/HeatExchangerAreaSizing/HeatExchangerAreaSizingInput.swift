import Foundation

struct HeatExchangerAreaSizingInput:
    Equatable,
    Sendable {

    let flowArrangement:
        HeatExchangerFlowArrangement

    let hotInletTemperature: Double
    let hotOutletTemperature: Double

    let coldInletTemperature: Double
    let coldOutletTemperature: Double

    let requiredHeatTransferRate: Double

    let overallHeatTransferCoefficient: Double

    let correctionFactor: Double
}
