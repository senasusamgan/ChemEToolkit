import Foundation

enum HeatExchangerFlowArrangement:
    String,
    CaseIterable,
    Identifiable,
    Hashable,
    Sendable {

    case parallelFlow
    case counterFlow

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .parallelFlow:
            return "Parallel Flow"

        case .counterFlow:
            return "Counter Flow"
        }
    }

    var explanation: String {
        switch self {
        case .parallelFlow:
            return """
            The hot and cold streams enter from the same \
            end of the heat exchanger.
            """

        case .counterFlow:
            return """
            The hot and cold streams enter from opposite \
            ends of the heat exchanger.
            """
        }
    }
}

struct HeatExchangerLMTDInput:
    Equatable,
    Sendable {

    let flowArrangement:
        HeatExchangerFlowArrangement

    let hotInletTemperature: Double
    let hotOutletTemperature: Double

    let coldInletTemperature: Double
    let coldOutletTemperature: Double

    let overallHeatTransferCoefficient: Double
    let heatTransferArea: Double

    /// LMTD correction factor. Must be greater than
    /// zero and no greater than one.
    let correctionFactor: Double
}
