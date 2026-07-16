enum LaplaceTransformFunction:
    String,
    CaseIterable,
    Identifiable,
    Equatable,
    Sendable {

    case constant
    case ramp
    case exponential
    case sine
    case cosine

    var id: String { rawValue }

    var title: String {
        switch self {
        case .constant: return "Constant: A"
        case .ramp: return "Ramp: A·t"
        case .exponential: return "Exponential: A·e^(a·t)"
        case .sine: return "Sine: A·sin(ωt)"
        case .cosine: return "Cosine: A·cos(ωt)"
        }
    }
}

struct LaplaceTransformHelperInput:
    Equatable,
    Sendable {

    let function: LaplaceTransformFunction
    let amplitude: Double
    let parameter: Double
    let evaluationS: Double
}
