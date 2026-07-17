struct EconomicSensitivityAnalysisInput:
    Equatable,
    Sendable {

    let baseAnnualRevenue: Double
    let baseAnnualOperatingCost:
        Double
    let baseCapitalInvestment:
        Double

    let revenueChangeFraction:
        Double
    let operatingCostChangeFraction:
        Double
    let capitalChangeFraction:
        Double

    let projectLifeYears: Double
    let discountRateFraction:
        Double
}
