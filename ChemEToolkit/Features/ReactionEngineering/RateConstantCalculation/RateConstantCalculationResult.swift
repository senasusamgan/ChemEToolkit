struct RateConstantCalculationResult:
    Equatable,
    Sendable {

    let rateConstant: Double
    let overallReactionOrder: Double
    let concentrationProduct: Double
    let observedConstantWithBFixed: Double
    let observedConstantWithAFixed: Double
    let rateConstantUnitsDescription: String
    let rateLawExpression: String
}
