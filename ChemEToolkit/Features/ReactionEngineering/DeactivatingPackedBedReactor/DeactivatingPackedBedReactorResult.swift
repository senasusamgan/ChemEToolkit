struct DeactivatingPackedBedReactorResult:
    Equatable,
    Sendable {

    let catalystActivity: Double

    let freshDamkohlerNumber: Double
    let currentDamkohlerNumber:
        Double

    let freshConversion: Double
    let currentConversion: Double
    let outletConcentrationA: Double

    let conversionLoss:
        Double

    let requiredCatalystWeightForTarget:
        Double
    let requiredWeightMultiplier:
        Double

    let modelName: String
    let limitationDescription: String
}
