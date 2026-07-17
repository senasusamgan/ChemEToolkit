struct StreamSplitterBalanceInput:
    Equatable,
    Sendable {

    let feedMassFlow: Double
    let product1SplitFraction:
        Double
    let feedComponentMassFraction:
        Double
}
