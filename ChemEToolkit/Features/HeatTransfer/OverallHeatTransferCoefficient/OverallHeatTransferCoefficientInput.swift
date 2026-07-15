import Foundation

struct OverallHeatTransferCoefficientInput:
    Equatable,
    Sendable {

    let hotSideHeatTransferCoefficient: Double
    let coldSideHeatTransferCoefficient: Double

    let wallThermalConductivity: Double
    let wallThickness: Double

    /// Area-normalized fouling resistance, m²·K/W.
    let hotSideFoulingResistance: Double

    /// Area-normalized fouling resistance, m²·K/W.
    let coldSideFoulingResistance: Double
}
