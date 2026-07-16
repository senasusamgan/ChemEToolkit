struct RatioControlResult:
    Equatable,
    Sendable {

    let idealControlledFlowSetpoint:
        Double
    let requestedControlledFlowSetpoint:
        Double
    let appliedControlledFlowSetpoint:
        Double

    let measuredFlowRatio: Double?
    let ratioError: Double?
    let controlledFlowError: Double

    let setpointWasLimited: Bool
    let limitingAmount: Double

    let modelName: String
    let limitationDescription: String
}
