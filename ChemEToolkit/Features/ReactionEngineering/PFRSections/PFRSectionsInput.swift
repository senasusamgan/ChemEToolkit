struct PFRSectionsInput:
    Equatable,
    Sendable {

    let inletConcentration: Double
    let volumetricFlowRate: Double

    let sectionOneVolume: Double
    let sectionOneRateConstant: Double
    let sectionTwoVolume: Double
    let sectionTwoRateConstant: Double
    let sectionThreeVolume: Double
    let sectionThreeRateConstant: Double
}
