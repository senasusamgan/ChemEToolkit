struct EvaporatorBalanceInput:
    Equatable,
    Sendable {

    let feedMassFlow: Double
    let feedSoluteMassFraction:
        Double
    let productSoluteMassFraction:
        Double
}
