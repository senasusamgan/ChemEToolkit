struct LangFactorCapitalEstimateInput:
    Equatable,
    Sendable {

    let purchasedEquipmentCost:
        Double
    let langFactor: Double

    let landCost: Double
    let workingCapitalFractionOfFixedCapital:
        Double
    let startupExpenseFractionOfFixedCapital:
        Double
}
