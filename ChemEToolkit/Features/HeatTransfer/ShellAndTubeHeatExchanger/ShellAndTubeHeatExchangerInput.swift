import Foundation

struct ShellAndTubeHeatExchangerInput:
    Equatable,
    Sendable {

    let hotInletTemperature: Double
    let hotOutletTemperature: Double

    let coldInletTemperature: Double
    let coldOutletTemperature: Double

    let requiredHeatTransferRate: Double
    let overallHeatTransferCoefficient: Double
    let correctionFactor: Double

    let tubeOuterDiameter: Double
    let tubeLength: Double

    let numberOfTubePasses: Int
}
