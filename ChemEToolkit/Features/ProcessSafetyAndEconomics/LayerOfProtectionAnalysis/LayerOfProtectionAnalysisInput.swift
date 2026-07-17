struct LayerOfProtectionAnalysisInput:
    Equatable,
    Sendable {

    let initiatingEventFrequency:
        Double
    let enablingConditionProbability:
        Double
    let conditionalModifierProbability:
        Double

    let protectionLayer1PFD:
        Double
    let protectionLayer2PFD:
        Double
    let protectionLayer3PFD:
        Double

    let tolerableEventFrequency:
        Double
}
