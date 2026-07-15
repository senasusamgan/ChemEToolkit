struct RateConstantTemperatureShiftInput:
    Equatable,
    Sendable {

    let referenceRateConstant: Double
    let referenceTemperature: Double
    let targetTemperature: Double
    let activationEnergy: Double
}
