struct ReactionPerformanceBalanceInput:
    Equatable,
    Sendable {

    let reactantFeedAmount:
        Double
    let reactantOutletAmount:
        Double
    let desiredProductAmount:
        Double
    let undesiredProductAmount:
        Double
}
