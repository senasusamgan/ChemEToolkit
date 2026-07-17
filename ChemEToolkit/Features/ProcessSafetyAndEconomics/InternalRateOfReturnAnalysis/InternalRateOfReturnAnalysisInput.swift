struct InternalRateOfReturnAnalysisInput:
    Equatable,
    Sendable {

    let initialInvestment: Double
    let annualNetCashFlow: Double
    let terminalValue: Double
    let projectLifeYears: Double

    let minimumSearchRate:
        Double
    let maximumSearchRate:
        Double
}
