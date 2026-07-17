struct BinarySeparatorBalanceResult:
    Equatable,
    Sendable {

    let product2MassFlow: Double

    let feedComponentFlow: Double
    let product1ComponentFlow:
        Double
    let product2ComponentFlow:
        Double

    let product2ComponentMassFraction:
        Double

    let componentRecoveryToProduct1:
        Double
    let componentRecoveryToProduct2:
        Double

    let modelName: String
    let limitationDescription: String
}
