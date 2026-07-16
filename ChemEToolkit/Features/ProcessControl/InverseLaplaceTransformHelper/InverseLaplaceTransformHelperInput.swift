enum InverseLaplaceTransformForm:
    String,
    CaseIterable,
    Identifiable,
    Equatable,
    Sendable {

    case constantOverS
    case constantOverSSquared
    case shiftedPole
    case cosineForm
    case sineForm
    case firstOrderStep

    var id: String { rawValue }

    var title: String {
        switch self {
        case .constantOverS: return "A / s"
        case .constantOverSSquared: return "A / s²"
        case .shiftedPole: return "A / (s + a)"
        case .cosineForm: return "A·s / (s² + ω²)"
        case .sineForm: return "A·ω / (s² + ω²)"
        case .firstOrderStep: return "A / [s(τs + 1)]"
        }
    }
}

struct InverseLaplaceTransformHelperInput:
    Equatable,
    Sendable {

    let form: InverseLaplaceTransformForm
    let amplitude: Double
    let parameter: Double
    let evaluationTime: Double
}
