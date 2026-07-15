struct CSTRPFRSequenceResult:
    Equatable,
    Sendable {

    let cstrOutletConcentration: Double
    let finalOutletConcentration: Double

    let cstrStageConversion: Double
    let pfrIncrementalConversionOnFeed: Double
    let overallConversion: Double

    let cstrSpaceTime: Double
    let pfrSpaceTime: Double
    let totalSpaceTime: Double
    let totalReactorVolume: Double

    let equivalentOverallFirstOrderConstant: Double

    let modelName: String
    let limitationDescription: String
}
