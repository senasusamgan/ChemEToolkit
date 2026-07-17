struct SignificantFiguresRoundingInput:
    Equatable,
    Sendable {

    let value: Double
    let significantDigitCount:
        Double
}
