import Foundation

struct FoulingAnalysisInput:
    Equatable,
    Sendable {

    let hotSideHeatTransferCoefficient: Double
    let coldSideHeatTransferCoefficient: Double

    let wallThermalConductivity: Double
    let wallThickness: Double

    let hotSideFoulingResistance: Double
    let coldSideFoulingResistance: Double

    let heatTransferArea: Double

    let hotSideTemperature: Double
    let coldSideTemperature: Double
}
