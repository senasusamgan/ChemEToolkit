struct AverageMolecularWeightResult:
    Equatable,
    Sendable {

    let enteredFractionSum: Double

    let normalizedFraction1: Double
    let normalizedFraction2: Double
    let normalizedFraction3: Double

    let averageMolecularWeight:
        Double
    let reciprocalAverageMolecularWeight:
        Double

    let modelName: String
    let limitationDescription: String
}
