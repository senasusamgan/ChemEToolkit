struct MembraneSeparatorBalanceInput:
    Equatable,
    Sendable {

    let feedMassFlow: Double
    let feedComponentMassFraction:
        Double
    let stageCutFraction: Double
    let observedRejectionFraction:
        Double
}
