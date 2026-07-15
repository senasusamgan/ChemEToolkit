import Foundation

struct DoublePipeHeatExchangerResult:
    Equatable,
    Sendable {

    let flowArrangement:
        HeatExchangerFlowArrangement

    let terminalTemperatureDifferenceOne: Double
    let terminalTemperatureDifferenceTwo: Double

    let logMeanTemperatureDifference: Double
    let correctedLogMeanTemperatureDifference: Double

    /// Total heat-transfer area required, m².
    let requiredHeatTransferArea: Double

    /// Required length of each parallel tube, m.
    let requiredLengthPerTube: Double

    /// Sum of the lengths of all parallel tubes, m.
    let totalTubeLength: Double

    let numberOfParallelTubes: Int

    /// Required UA value, W/K.
    let requiredOverallConductance: Double

    /// Design heat flux, W/m².
    let designHeatFlux: Double
}
