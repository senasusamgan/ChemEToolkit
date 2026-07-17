struct FilterCakeBalanceInput:
    Equatable,
    Sendable {

    let slurryFeedMassFlow: Double
    let feedDrySolidMassFraction:
        Double
    let cakeLiquidMassFraction:
        Double
}
