struct TransferFunctionBuilderResult:
    Equatable,
    Sendable {

    let transferFunctionExpression:
        String
    let numeratorOrder: Int
    let denominatorOrder: Int
    let propernessDescription: String

    let realPart: Double
    let imaginaryPart: Double
    let magnitude: Double
    let phaseDegrees: Double

    let dcGain: Double?
    let stabilityDescription: String

    let modelName: String
    let limitationDescription: String
}
