struct TotalCapitalInvestmentEstimateResult:
    Equatable,
    Sendable {

    let directPlantCost: Double
    let indirectPlantCost: Double
    let subtotalBeforeContingency:
        Double

    let contingencyCost: Double
    let fixedCapitalInvestment:
        Double
    let workingCapital: Double
    let totalCapitalInvestment:
        Double

    let fixedCapitalToEquipmentRatio:
        Double
    let equipmentFractionOfTotalInvestment:
        Double

    let modelName: String
    let limitationDescription: String
}
