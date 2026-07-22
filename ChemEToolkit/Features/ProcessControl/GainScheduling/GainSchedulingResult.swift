struct GainSchedulingResult:
    Equatable,
    Sendable {

    let interpolationFraction: Double

    let scheduledControllerGain:
        Double
    let scheduledIntegralTime:
        Double
    let scheduledDerivativeTime:
        Double

    let controllerGainSlope:
        Double
    let integralTimeSlope: Double
    let derivativeTimeSlope:
        Double

    let nearestScheduleRegion:
        String
    let transitionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
