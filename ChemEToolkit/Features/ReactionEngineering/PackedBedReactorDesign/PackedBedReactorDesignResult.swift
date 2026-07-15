struct PackedBedReactorDesignResult:
    Equatable,
    Sendable {

    let requiredCatalystWeight: Double

    let inletMolarFlowRateA: Double
    let outletMolarFlowRateA: Double
    let outletConcentrationA: Double

    let catalystSpaceTime: Double
    let firstOrderExposure: Double

    let inletRatePerCatalystMass:
        Double
    let outletRatePerCatalystMass:
        Double

    let modelName: String
    let limitationDescription: String
}
