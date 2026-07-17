struct CrystallizerBalanceInput:
    Equatable,
    Sendable {

    let feedMassFlow: Double
    let feedSoluteMassFraction:
        Double
    let motherLiquorSoluteMassFraction:
        Double
    let crystalSoluteMassFraction:
        Double
}
