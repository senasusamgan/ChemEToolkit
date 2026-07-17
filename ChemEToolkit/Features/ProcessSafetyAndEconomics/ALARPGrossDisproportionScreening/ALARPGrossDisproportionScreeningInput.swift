struct ALARPGrossDisproportionScreeningInput:
    Equatable,
    Sendable {

    let riskReductionMeasureCost:
        Double
    let annualizedLossReduction:
        Double
    let projectLifeYears: Double
    let discountRateFraction:
        Double
    let grossDisproportionFactor:
        Double
}
