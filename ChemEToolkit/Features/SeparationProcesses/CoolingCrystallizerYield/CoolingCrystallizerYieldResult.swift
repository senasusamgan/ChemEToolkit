struct CoolingCrystallizerYieldResult:
    Equatable,
    Sendable {

    let initialDissolvedSolute: Double
    let finalDissolvedSolute: Double
    let pureCrystalMass: Double
    let recoveredCrystalProduct: Double
    let soluteRecoveryFraction: Double

    let modelName: String
    let limitationDescription: String
}
