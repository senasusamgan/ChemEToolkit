struct InternalModelControlAnalysisResult:
    Equatable,
    Sendable {

    let equivalentPIControllerGain:
        Double
    let equivalentPIIntegralTime:
        Double

    let imcControllerMagnitude:
        Double
    let imcControllerPhaseDegrees:
        Double

    let nominalClosedLoopMagnitude:
        Double
    let nominalClosedLoopPhaseDegrees:
        Double

    let gainMismatchFraction: Double
    let timeConstantMismatchFraction:
        Double
    let robustnessDescription: String

    let modelName: String
    let limitationDescription: String
}
