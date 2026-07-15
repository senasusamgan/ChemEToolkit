struct ParallelReactionsInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double

    let desiredFirstOrderRateConstant:
        Double
    let undesiredFirstOrderRateConstant:
        Double

    let reactionTime: Double
}
