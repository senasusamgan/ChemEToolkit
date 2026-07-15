struct RateConstantTemperatureShiftResult:
    Equatable,
    Sendable {

    let targetRateConstant: Double
    let rateConstantRatio: Double
    let naturalLogRateRatio: Double
    let reciprocalTemperatureChange:
        Double
    let percentRateConstantChange: Double

    let trendDescription: String
    let modelName: String
    let limitationDescription: String
}
