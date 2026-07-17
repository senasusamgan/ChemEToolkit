struct RecyclePurgeInertBalanceInput:
    Equatable,
    Sendable {

    let freshFeedMassFlow: Double
    let freshFeedInertMassFraction:
        Double

    let singlePassReactantConversion:
        Double
    let purgeFraction: Double
}
