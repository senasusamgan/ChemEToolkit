struct LifecycleCostAnalysisResult:
    Equatable,
    Sendable {

    let projectLifeYears: Int
    let replacementIntervalYears:
        Int

    let presentValueOfOperatingCost:
        Double
    let presentValueOfMaintenanceCost:
        Double
    let presentValueOfReplacementCost:
        Double
    let presentValueOfSalvageValue:
        Double

    let totalLifecycleCost: Double
    let equivalentAnnualCost: Double
    let replacementCount: Int

    let dominantCostCategory: String

    let modelName: String
    let limitationDescription: String
}
