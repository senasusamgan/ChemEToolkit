struct RateLawBuilderResult:
    Equatable,
    Sendable {

    let overallReactionOrder: Double
    let rateConstantConcentrationExponent: Double
    let powerLawExpression: String
    let stoichiometricRateRelationship: String
    let rateConstantUnitsDescription: String
    let isConsistentWithElementaryStep: Bool
    let consistencyDescription: String
}
