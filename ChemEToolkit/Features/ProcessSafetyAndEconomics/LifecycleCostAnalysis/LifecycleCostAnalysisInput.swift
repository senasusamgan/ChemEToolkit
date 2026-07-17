struct LifecycleCostAnalysisInput:
    Equatable,
    Sendable {

    let initialCapitalCost: Double
    let annualOperatingCost: Double
    let annualMaintenanceCost: Double
    let periodicReplacementCost:
        Double
    let replacementIntervalYears:
        Double
    let terminalSalvageValue: Double
    let projectLifeYears: Double
    let discountRateFraction:
        Double
}
