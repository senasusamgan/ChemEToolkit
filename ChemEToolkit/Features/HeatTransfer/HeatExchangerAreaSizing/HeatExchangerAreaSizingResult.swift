import Foundation

struct HeatExchangerAreaSizingResult:
    Equatable,
    Sendable {

    let flowArrangement:
        HeatExchangerFlowArrangement

    let terminalTemperatureDifferenceOne: Double
    let terminalTemperatureDifferenceTwo: Double

    let logMeanTemperatureDifference: Double

    let correctionFactor: Double

    let correctedLogMeanTemperatureDifference: Double

    /// Required heat-transfer area, m².
    let requiredArea: Double

    /// Required duty divided by area, W/m².
    let designHeatFlux: Double

    /// U × A, W/K.
    let requiredOverallConductance: Double
}
