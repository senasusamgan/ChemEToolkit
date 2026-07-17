struct DaltonPartialPressureResult:
    Equatable,
    Sendable {

    let enteredFractionSum: Double
    let normalizedFraction1: Double
    let normalizedFraction2: Double
    let normalizedFraction3: Double

    let partialPressure1: Double
    let partialPressure2: Double
    let partialPressure3: Double
    let partialPressureSum: Double

    let modelName: String
    let limitationDescription: String
}
