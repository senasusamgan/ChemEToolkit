struct StreamSplitterBalanceResult:
    Equatable,
    Sendable {

    let product1MassFlow: Double
    let product2MassFlow: Double

    let product1ComponentFlow:
        Double
    let product2ComponentFlow:
        Double

    let product1OtherComponentFlow:
        Double
    let product2OtherComponentFlow:
        Double

    let modelName: String
    let limitationDescription: String
}
