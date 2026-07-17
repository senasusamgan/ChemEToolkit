struct AnnualOperatingCostEstimateResult:
    Equatable,
    Sendable {

    let directCashOperatingCost:
        Double
    let plantOverheadCost: Double
    let insuranceAndTaxCost: Double

    let totalAnnualOperatingCost:
        Double
    let unitProductionCost: Double

    let variableCostFraction: Double
    let laborAndMaintenanceFraction:
        Double

    let largestCostCategory:
        String

    let modelName: String
    let limitationDescription: String
}
