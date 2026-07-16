struct EconomicReactorSelectionResult:
    Equatable,
    Sendable {

    let requiredPFRVolume: Double
    let requiredCSTRVolume: Double

    let pfrInstalledCapitalCost:
        Double
    let cstrInstalledCapitalCost:
        Double

    let pfrEquivalentAnnualCost:
        Double
    let cstrEquivalentAnnualCost:
        Double

    let preferredReactor: String
    let annualSavings: Double
    let relativeSavingsFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
