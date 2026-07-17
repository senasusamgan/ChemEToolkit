struct SignificantFiguresRoundingResult:
    Equatable,
    Sendable {

    let significantDigitCount:
        Int
    let roundedValue: Double
    let decimalPlacesApplied:
        Int
    let absoluteRoundingDifference:
        Double
    let relativeRoundingDifferencePercent:
        Double

    let modelName: String
    let limitationDescription: String
}
