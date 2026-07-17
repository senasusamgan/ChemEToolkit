struct BinarySeparatorBalanceInput:
    Equatable,
    Sendable {

    let feedMassFlow: Double
    let feedComponentMassFraction:
        Double

    let product1MassFlow: Double
    let product1ComponentMassFraction:
        Double
}
