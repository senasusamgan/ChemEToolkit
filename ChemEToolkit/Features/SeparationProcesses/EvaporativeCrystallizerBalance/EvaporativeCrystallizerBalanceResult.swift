struct EvaporativeCrystallizerBalanceResult:
    Equatable,
    Sendable {

    let crystalProductFlow: Double
    let motherLiquorFlow: Double
    let pureSoluteInCrystals: Double
    let soluteRecoveryFraction: Double
    let totalMassClosure: Double

    let modelName: String
    let limitationDescription: String
}
