struct ClausiusClapeyronEstimatorResult:
    Equatable,
    Sendable {

    let inverseTemperatureDifference:
        Double
    let naturalLogPressureRatio:
        Double
    let pressureRatio: Double
    let targetPressure: Double
    let trendDescription: String

    let modelName: String
    let limitationDescription: String
}
