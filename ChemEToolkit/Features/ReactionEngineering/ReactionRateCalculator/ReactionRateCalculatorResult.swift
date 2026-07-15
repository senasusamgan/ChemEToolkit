struct ReactionRateCalculatorResult:
    Equatable,
    Sendable {

    let overallReactionOrder: Double
    let rateOfReaction: Double
    let disappearanceRateA: Double
    let disappearanceRateB: Double
    let characteristicTimeForA: Double
    let rateConstantUnitsDescription: String
    let rateLawExpression: String
}
