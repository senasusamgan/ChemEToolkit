struct BreakEvenProductionAnalysisInput:
    Equatable,
    Sendable {

    let annualFixedCost: Double
    let sellingPricePerUnit:
        Double
    let variableCostPerUnit:
        Double

    let expectedAnnualProduction:
        Double
    let maximumAnnualCapacity:
        Double
}
