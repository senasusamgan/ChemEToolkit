struct RecyclePFRResult:
    Equatable,
    Sendable {

    let totalReactorFlowRate: Double
    let reactorResidenceTime: Double

    let reactorInletConcentration: Double
    let reactorOutletConcentration: Double

    let singlePassConversion: Double
    let overallFreshFeedConversion: Double

    let recycledVolumetricFlowRate: Double
    let recycledReactantMolarRate: Double

    let noRecyclePFRConversion: Double
    let conversionPenaltyFromRecycle: Double

    let modelName: String
    let limitationDescription: String
}
