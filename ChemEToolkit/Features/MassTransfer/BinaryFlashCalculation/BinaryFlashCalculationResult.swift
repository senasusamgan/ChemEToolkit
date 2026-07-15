enum BinaryFlashPhaseState: String, Equatable, Sendable {
    case allLiquid
    case bubblePoint
    case twoPhase
    case dewPoint
    case allVapor

    var title: String {
        switch self {
        case .allLiquid: return "Single liquid phase"
        case .bubblePoint: return "Bubble-point boundary"
        case .twoPhase: return "Two-phase flash"
        case .dewPoint: return "Dew-point boundary"
        case .allVapor: return "Single vapor phase"
        }
    }
}

struct BinaryFlashCalculationResult: Equatable, Sendable {
    let phaseState: BinaryFlashPhaseState
    let vaporFraction: Double
    let liquidFraction: Double
    let vaporFlowRate: Double
    let liquidFlowRate: Double
    let vaporLightMoleFraction: Double
    let liquidLightMoleFraction: Double
    let rachfordRiceResidual: Double
    let modelName: String
}
