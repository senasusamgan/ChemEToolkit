struct RaoultBubblePointPressureResult:
    Equatable,
    Sendable {

    let bubblePointPressure: Double
    let vaporMoleFraction1: Double
    let vaporMoleFraction2: Double
    let partialPressure1: Double
    let partialPressure2: Double
    let relativeVolatility:
        Double

    let modelName: String
    let limitationDescription: String
}
