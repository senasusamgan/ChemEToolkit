struct LinearInterpolationCalculatorResult:
    Equatable,
    Sendable {

    let interpolatedY: Double
    let interpolationFraction:
        Double
    let slope: Double

    let isExtrapolation: Bool
    let rangeDescription: String

    let modelName: String
    let limitationDescription: String
}
