struct RateLawBuilderInput:
    Equatable,
    Sendable {

    let stoichiometricCoefficientA: Double
    let stoichiometricCoefficientB: Double
    let reactionOrderA: Double
    let reactionOrderB: Double
}
