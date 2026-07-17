struct PaybackAndROIAnalysisInput:
    Equatable,
    Sendable {

    let initialInvestment: Double
    let annualRevenue: Double
    let annualCashOperatingCost:
        Double
    let annualDepreciation: Double

    let incomeTaxRateFraction:
        Double
    let salvageValue: Double
    let projectLifeYears: Double
}
