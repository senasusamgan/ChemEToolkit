enum LimitingReactantDescription:
    String,
    Equatable,
    Sendable {

    case reactantA
    case reactantB
    case stoichiometricFeed

    var title: String {
        switch self {
        case .reactantA:
            return "Reactant A limits complete conversion."
        case .reactantB:
            return "Reactant B limits complete conversion."
        case .stoichiometricFeed:
            return "The feed is stoichiometric."
        }
    }
}

struct ConstantVolumeStoichiometryResult:
    Equatable,
    Sendable {

    let reactionExtentPerVolume: Double

    let finalConcentrationA: Double
    let finalConcentrationB: Double
    let finalConcentrationProduct:
        Double

    let concentrationAConsumed: Double
    let concentrationBConsumed: Double
    let productConcentrationFormed:
        Double

    let conversionOfB: Double
    let maximumFeasibleConversionOfA:
        Double

    let limitingReactant:
        LimitingReactantDescription
    let stoichiometricFeedRatioBToA:
        Double
    let actualFeedRatioBToA: Double

    let modelName: String
    let limitationDescription: String
}
