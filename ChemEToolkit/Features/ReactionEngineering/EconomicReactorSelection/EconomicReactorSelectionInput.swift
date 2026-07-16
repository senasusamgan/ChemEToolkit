struct EconomicReactorSelectionInput:
    Equatable,
    Sendable {

    let volumetricFlowRate: Double
    let firstOrderRateConstant:
        Double
    let targetConversion: Double

    let pfrInstalledCostPerVolume:
        Double
    let cstrInstalledCostPerVolume:
        Double

    let annualizationFactor:
        Double

    let pfrAnnualOperatingCost:
        Double
    let cstrAnnualOperatingCost:
        Double
}
