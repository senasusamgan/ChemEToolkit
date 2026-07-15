struct ReactionRateCalculatorInput:
    Equatable,
    Sendable {

    let rateConstant: Double
    let concentrationA: Double
    let concentrationB: Double
    let reactionOrderA: Double
    let reactionOrderB: Double
    let stoichiometricCoefficientA: Double
    let stoichiometricCoefficientB: Double
}
