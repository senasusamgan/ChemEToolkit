struct BreakEvenProductionAnalysisResult:
    Equatable,
    Sendable {

    let contributionMarginPerUnit:
        Double

    let breakEvenProduction:
        Double
    let breakEvenSalesRevenue:
        Double
    let breakEvenCapacityFraction:
        Double

    let expectedAnnualProfit:
        Double
    let expectedMarginOfSafetyUnits:
        Double
    let expectedMarginOfSafetyFraction:
        Double

    let breakEvenIsWithinCapacity:
        Bool
    let profitabilityDescription:
        String

    let modelName: String
    let limitationDescription: String
}
