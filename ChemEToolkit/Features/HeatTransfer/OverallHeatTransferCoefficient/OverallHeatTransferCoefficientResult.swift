import Foundation

struct OverallHeatTransferCoefficientResult:
    Equatable,
    Sendable {

    /// 1 / h_hot, m²·K/W.
    let hotSideConvectionResistance: Double

    /// Hot-side fouling resistance, m²·K/W.
    let hotSideFoulingResistance: Double

    /// L / k, m²·K/W.
    let wallConductionResistance: Double

    /// Cold-side fouling resistance, m²·K/W.
    let coldSideFoulingResistance: Double

    /// 1 / h_cold, m²·K/W.
    let coldSideConvectionResistance: Double

    /// Sum of all area-normalized resistances, m²·K/W.
    let totalResistancePerUnitArea: Double

    /// Overall heat-transfer coefficient, W/(m²·K).
    let overallHeatTransferCoefficient: Double
}
