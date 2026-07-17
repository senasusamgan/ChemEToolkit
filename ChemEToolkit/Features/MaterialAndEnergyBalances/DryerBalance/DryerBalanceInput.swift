struct DryerBalanceInput:
    Equatable,
    Sendable {

    let wetFeedMassFlow: Double
    let initialMoistureWetBasis:
        Double
    let targetMoistureWetBasis:
        Double
}
