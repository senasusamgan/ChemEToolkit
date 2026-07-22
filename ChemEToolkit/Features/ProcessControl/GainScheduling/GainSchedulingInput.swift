struct GainSchedulingInput:
    Equatable,
    Sendable {

    let operatingPoint: Double
    let lowerOperatingPoint: Double
    let upperOperatingPoint: Double

    let lowerControllerGain: Double
    let upperControllerGain: Double

    let lowerIntegralTime: Double
    let upperIntegralTime: Double

    let lowerDerivativeTime: Double
    let upperDerivativeTime: Double
}
