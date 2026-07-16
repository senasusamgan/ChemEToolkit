struct ECurveGeneratorResult:
    Equatable,
    Sendable {

    let rawTracerArea: Double
    let normalizedArea: Double

    let eValues: [Double]
    let dimensionlessTimes: [Double]

    let meanResidenceTime: Double
    let peakTime: Double
    let peakEValue: Double

    let modelName: String
    let limitationDescription: String
}
