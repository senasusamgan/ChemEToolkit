import Foundation

struct HeatExchangerLMTDResult:
    Equatable,
    Sendable {

    let flowArrangement:
        HeatExchangerFlowArrangement

    /// First terminal temperature difference, K.
    let terminalTemperatureDifferenceOne: Double

    /// Second terminal temperature difference, K.
    let terminalTemperatureDifferenceTwo: Double

    /// Uncorrected log-mean temperature difference, K.
    let logMeanTemperatureDifference: Double

    /// User-supplied correction factor.
    let correctionFactor: Double

    /// F × LMTD, K.
    let correctedLogMeanTemperatureDifference: Double

    /// U × A, W/K.
    let overallConductance: Double

    /// Q̇ = U A F LMTD, W.
    let heatTransferRate: Double

    /// Q̇ / A, W/m².
    let heatFlux: Double
}
