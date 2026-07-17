struct RiskReductionCostEffectivenessInput:
    Equatable,
    Sendable {

    let currentAnnualizedLoss: Double
    let residualAnnualizedLoss: Double
    let initialRiskReductionInvestment: Double
    let annualMaintenanceCost: Double
    let projectLifeYears: Double
    let discountRateFraction: Double
}
