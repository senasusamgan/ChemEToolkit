struct ConversionFromRTDInput: Equatable, Sendable {
    let firstOrderRateConstant: Double
    let times: [Double]
    let eValues: [Double]
}
