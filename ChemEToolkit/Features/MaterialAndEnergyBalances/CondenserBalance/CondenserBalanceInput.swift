struct CondenserBalanceInput:
    Equatable,
    Sendable {

    let vaporFeedMassFlow: Double
    let condensableMassFraction:
        Double
    let condensableCondensationFraction:
        Double
}
