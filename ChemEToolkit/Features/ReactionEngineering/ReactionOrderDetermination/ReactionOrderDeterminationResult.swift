enum ReactionOrderClassification:
    String,
    Equatable,
    Sendable {

    case zeroOrder
    case firstOrder
    case secondOrder
    case fractionalOrOther

    var title: String {
        switch self {
        case .zeroOrder:
            return "Approximately zero order"
        case .firstOrder:
            return "Approximately first order"
        case .secondOrder:
            return "Approximately second order"
        case .fractionalOrOther:
            return "Fractional or non-integer order"
        }
    }
}

struct ReactionOrderDeterminationResult:
    Equatable,
    Sendable {

    let reactionOrder: Double
    let classification: ReactionOrderClassification
    let rateConstantFromExperimentOne: Double
    let rateConstantFromExperimentTwo: Double
    let averageRateConstant: Double
    let relativeRateConstantMismatch: Double
    let rateConstantUnitsDescription: String
}
