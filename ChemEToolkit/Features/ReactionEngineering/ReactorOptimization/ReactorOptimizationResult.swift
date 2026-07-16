struct ReactorOptimizationResult:
    Equatable,
    Sendable {

    let optimumPFRSpaceTime: Double
    let optimumPFRVolume: Double
    let maximumPFRConcentrationB:
        Double
    let maximumPFRYieldB: Double

    let optimumCSTRSpaceTime:
        Double
    let optimumCSTRVolume: Double
    let maximumCSTRConcentrationB:
        Double
    let maximumCSTRYieldB: Double

    let recommendedReactor:
        String
    let yieldAdvantage:
        Double

    let modelName: String
    let limitationDescription: String
}
