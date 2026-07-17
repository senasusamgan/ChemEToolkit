struct LayerOfProtectionAnalysisResult:
    Equatable,
    Sendable {

    let unmitigatedScenarioFrequency:
        Double
    let combinedProtectionLayerPFD:
        Double
    let mitigatedScenarioFrequency:
        Double

    let achievedRiskReductionFactor:
        Double
    let requiredAdditionalRiskReductionFactor:
        Double

    let targetIsMet: Bool
    let activeProtectionLayerCount:
        Int
    let assessmentDescription:
        String

    let modelName: String
    let limitationDescription: String
}
