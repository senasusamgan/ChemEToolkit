struct LangFactorCapitalEstimateResult:
    Equatable,
    Sendable {

    let purchasedEquipmentCost:
        Double
    let fixedCapitalInvestment:
        Double
    let langFactorAddedCost:
        Double

    let landCost: Double
    let workingCapital: Double
    let startupExpense: Double

    let totalCapitalInvestment:
        Double
    let totalInvestmentToEquipmentRatio:
        Double

    let modelName: String
    let limitationDescription: String
}
