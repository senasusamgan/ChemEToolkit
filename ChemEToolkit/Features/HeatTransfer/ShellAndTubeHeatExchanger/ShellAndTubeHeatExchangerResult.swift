import Foundation

struct ShellAndTubeHeatExchangerResult:
    Equatable,
    Sendable {

    let terminalTemperatureDifferenceOne: Double
    let terminalTemperatureDifferenceTwo: Double

    let logMeanTemperatureDifference: Double
    let correctedLogMeanTemperatureDifference: Double

    let requiredHeatTransferArea: Double
    let heatTransferAreaPerTube: Double

    let exactTubeCount: Double
    let selectedTubeCount: Int

    let numberOfTubePasses: Int
    let tubesPerPass: Int

    let providedHeatTransferArea: Double
    let areaDesignMarginPercentage: Double

    let requiredOverallConductance: Double
    let providedHeatTransferRate: Double
}
