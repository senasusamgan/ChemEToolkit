struct AnnualOperatingCostEstimateInput:
    Equatable,
    Sendable {

    let rawMaterialCost: Double
    let utilityCost: Double
    let operatingLaborCost: Double
    let maintenanceCost: Double
    let wasteTreatmentCost: Double
    let laboratoryAndQualityCost:
        Double

    let plantOverheadFractionOfLaborAndMaintenance:
        Double

    let insuranceAndTaxFractionOfFixedCapital:
        Double

    let fixedCapitalInvestment:
        Double
    let annualProduction: Double
}
