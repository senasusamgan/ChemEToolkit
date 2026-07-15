struct RateConstantCalculationInput:
    Equatable,
    Sendable {

    let measuredReactionRate: Double
    let concentrationA: Double
    let concentrationB: Double
    let reactionOrderA: Double
    let reactionOrderB: Double
}
