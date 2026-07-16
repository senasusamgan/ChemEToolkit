struct LiquidLevelDynamicsResult:
    Equatable,
    Sendable {

    let timeConstant: Double
    let processGain: Double

    let levelAtEvaluationTime:
        Double
    let finalSteadyStateLevel:
        Double

    let initialLevelRate: Double
    let fractionOfFinalChange:
        Double

    let overflowRisk: Bool
    let availableLevelMargin:
        Double

    let modelName: String
    let limitationDescription: String
}
