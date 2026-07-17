struct BinaryDistillationBalanceInput:
    Equatable,
    Sendable {

    let feedMolarFlow: Double
    let feedLightMoleFraction:
        Double
    let distillateLightMoleFraction:
        Double
    let bottomsLightMoleFraction:
        Double
}
