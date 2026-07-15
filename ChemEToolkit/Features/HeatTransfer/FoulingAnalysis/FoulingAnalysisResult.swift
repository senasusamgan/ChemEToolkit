import Foundation

struct FoulingAnalysisResult:
    Equatable,
    Sendable {

    let cleanResistancePerUnitArea: Double
    let fouledResistancePerUnitArea: Double

    let cleanOverallCoefficient: Double
    let fouledOverallCoefficient: Double

    let cleanHeatTransferRate: Double
    let fouledHeatTransferRate: Double

    let coefficientRetentionRatio: Double
    let performanceLossPercentage: Double

    let totalFoulingResistance: Double
    let temperatureDifference: Double
}
