struct StraightLineDepreciationInput:
    Equatable,
    Sendable {

    let depreciableAssetCost:
        Double
    let salvageValue: Double
    let serviceLifeYears: Double
    let evaluationAgeYears: Double
}
