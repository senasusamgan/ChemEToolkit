import Foundation

enum HeatExchangerNTUArrangement:
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
}

struct HeatExchangerEffectivenessNTUInput:
    Equatable,
    Sendable {

    let flowArrangement:
        HeatExchangerNTUArrangement

    let hotInletTemperature: Double
    let coldInletTemperature: Double

    /// Hot-stream mass flow rate, kg/s.
    let hotMassFlowRate: Double

    /// Cold-stream mass flow rate, kg/s.
    let coldMassFlowRate: Double

    /// Hot-stream specific heat, J/(kg·K).
    let hotSpecificHeatCapacity: Double

    /// Cold-stream specific heat, J/(kg·K).
    let coldSpecificHeatCapacity: Double

    /// Overall heat-transfer coefficient, W/(m²·K).
    let overallHeatTransferCoefficient: Double

    /// Heat-transfer area, m².
    let heatTransferArea: Double
}
