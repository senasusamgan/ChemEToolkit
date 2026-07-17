struct SolidsWashingBalanceResult:
    Equatable,
    Sendable {

    let initialSoluteMass: Double
    let totalMixedLiquidMass:
        Double
    let mixedLiquidSoluteMassFraction:
        Double

    let finalRetainedSoluteMass:
        Double
    let washEffluentMass: Double
    let soluteRemovedMass: Double
    let soluteRemovalFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
