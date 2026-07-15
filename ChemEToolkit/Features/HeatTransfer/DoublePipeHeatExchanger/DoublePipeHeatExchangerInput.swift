import Foundation

struct DoublePipeHeatExchangerInput:
    Equatable,
    Sendable {

    let flowArrangement:
        HeatExchangerFlowArrangement

    let hotInletTemperature: Double
    let hotOutletTemperature: Double

    let coldInletTemperature: Double
    let coldOutletTemperature: Double

    /// Required exchanger duty, W.
    let requiredHeatTransferRate: Double

    /// Overall heat-transfer coefficient, W/(m²·K).
    let overallHeatTransferCoefficient: Double

    /// Outer diameter of the heat-transfer tube, m.
    let tubeOuterDiameter: Double

    /// Number of equal parallel inner tubes.
    let numberOfParallelTubes: Int

    /// LMTD correction factor.
    let correctionFactor: Double
}
