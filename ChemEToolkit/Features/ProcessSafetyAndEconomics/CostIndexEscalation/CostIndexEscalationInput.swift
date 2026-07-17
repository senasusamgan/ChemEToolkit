struct CostIndexEscalationInput:
    Equatable,
    Sendable {

    let baseCost: Double
    let baseCostIndex: Double
    let targetCostIndex: Double
    let elapsedYears: Double
}
