struct BypassMixingBalanceInput:
    Equatable,
    Sendable {

    let feedMassFlow: Double
    let feedComponentMassFraction:
        Double

    let bypassFraction: Double
    let processedStreamComponentMassFraction:
        Double
}
