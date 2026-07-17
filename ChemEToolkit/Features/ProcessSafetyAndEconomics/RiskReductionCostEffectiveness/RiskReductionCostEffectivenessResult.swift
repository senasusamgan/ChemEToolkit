struct RiskReductionCostEffectivenessResult:
    Equatable,
    Sendable {

    let projectLifeYears: Int
    let annualLossReduction: Double
    let presentValueOfLossReduction: Double
    let presentValueOfMaintenanceCost: Double
    let netPresentValueOfRiskReduction: Double
    let benefitCostRatio: Double
    let simplePaybackYears: Double?
    let economicallyFavorable: Bool
    let assessmentDescription: String

    let modelName: String
    let limitationDescription: String
}
