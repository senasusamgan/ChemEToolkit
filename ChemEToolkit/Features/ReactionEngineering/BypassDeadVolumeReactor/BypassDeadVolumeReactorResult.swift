struct BypassDeadVolumeReactorResult:
    Equatable,
    Sendable {

    let nominalSpaceTime: Double

    let activeReactorVolume: Double
    let reactorPathFlowRate: Double
    let activePathSpaceTime: Double

    let activePathConversion: Double
    let overallConversion: Double
    let outletUnreactedFraction:
        Double

    let idealNominalPFRConversion:
        Double
    let conversionPenalty: Double

    let modelName: String
    let limitationDescription: String
}
