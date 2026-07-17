struct NetPresentValueAnalysisInput:
    Equatable,
    Sendable {

    let initialInvestment: Double
    let annualNetCashFlow: Double
    let projectLifeYears: Double

    let discountRateFraction:
        Double
    let terminalValue: Double
}
