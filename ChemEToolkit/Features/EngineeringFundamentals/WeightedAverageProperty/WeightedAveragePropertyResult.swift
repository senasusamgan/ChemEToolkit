struct WeightedAveragePropertyResult:
    Equatable,
    Sendable {

    let enteredFractionSum: Double

    let normalizedFraction1: Double
    let normalizedFraction2: Double
    let normalizedFraction3: Double

    let weightedAverageProperty:
        Double
    let minimumComponentProperty:
        Double
    let maximumComponentProperty:
        Double

    let modelName: String
    let limitationDescription: String
}
