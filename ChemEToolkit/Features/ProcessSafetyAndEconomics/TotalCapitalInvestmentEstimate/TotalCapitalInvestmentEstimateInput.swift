struct TotalCapitalInvestmentEstimateInput:
    Equatable,
    Sendable {

    let purchasedEquipmentCost:
        Double
    let equipmentInstallationCost:
        Double
    let pipingCost: Double
    let instrumentationCost: Double
    let electricalCost: Double
    let buildingsAndYardCost:
        Double
    let utilitiesAndServiceFacilitiesCost:
        Double

    let engineeringAndConstructionCost:
        Double

    let contingencyFractionOfSubtotal:
        Double
    let workingCapitalFractionOfFixedCapital:
        Double
}
