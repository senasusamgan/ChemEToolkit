struct PaybackAndROIAnalysisResult:
    Equatable,
    Sendable {

    let projectLifeYears: Int

    let earningsBeforeTax: Double
    let incomeTax: Double
    let annualNetIncome: Double
    let annualAfterTaxCashFlow:
        Double

    let simplePaybackYears: Double?
    let averageInvestment: Double
    let accountingROIFraction:
        Double

    let cumulativeAfterTaxCashFlow:
        Double
    let investmentRecoveredWithinLife:
        Bool

    let modelName: String
    let limitationDescription: String
}
