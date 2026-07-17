struct CrystallizerBalanceResult:
    Equatable,
    Sendable {

    let crystalMassFlow: Double
    let motherLiquorMassFlow:
        Double

    let feedSoluteFlow: Double
    let crystalSoluteFlow: Double
    let motherLiquorSoluteFlow:
        Double

    let soluteRecoveryToCrystals:
        Double
    let crystalYieldFromFeed:
        Double

    let modelName: String
    let limitationDescription: String
}
