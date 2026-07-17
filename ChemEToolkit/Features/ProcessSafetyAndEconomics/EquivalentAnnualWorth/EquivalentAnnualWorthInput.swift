struct EquivalentAnnualWorthInput:
    Equatable,
    Sendable {

    let initialInvestment: Double
    let annualNetCashFlow: Double
    let terminalValue: Double

    let projectLifeYears: Double
    let discountRateFraction:
        Double
}
