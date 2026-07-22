struct ReactiveMaterialBalanceResult:
    Equatable,
    Sendable {

    let reactantConsumedFlow:
        Double
    let reactantOutletFlow:
        Double
    let productFormationFlow:
        Double
    let reactionExtentRate:
        Double
    let totalOutletMolarFlow:
        Double
    let outletProductMoleFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
