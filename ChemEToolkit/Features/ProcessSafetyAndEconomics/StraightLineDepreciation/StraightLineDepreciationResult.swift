struct StraightLineDepreciationResult:
    Equatable,
    Sendable {

    let serviceLifeYears: Int
    let evaluationAgeYears: Int

    let depreciableBasis: Double
    let annualDepreciation: Double

    let accumulatedDepreciation:
        Double
    let bookValue: Double
    let remainingDepreciableBasis:
        Double

    let elapsedLifeFraction: Double
    let assetIsFullyDepreciated:
        Bool

    let modelName: String
    let limitationDescription: String
}
