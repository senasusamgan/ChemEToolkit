struct DeactivatingPackedBedReactorInput:
    Equatable,
    Sendable {

    let inletConcentrationA: Double
    let volumetricFlowRate: Double

    let catalystWeight: Double
    let freshCatalystRateCoefficient:
        Double

    let deactivationRateConstant:
        Double
    let timeOnStream: Double

    let targetConversion: Double
}
