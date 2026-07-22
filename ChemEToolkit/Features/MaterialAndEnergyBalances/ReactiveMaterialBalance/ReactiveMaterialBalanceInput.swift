struct ReactiveMaterialBalanceInput:
    Equatable,
    Sendable {

    let reactantFeedMolarFlow:
        Double
    let reactantStoichiometricCoefficient:
        Double
    let productStoichiometricCoefficient:
        Double
    let reactantConversionFraction:
        Double
}
