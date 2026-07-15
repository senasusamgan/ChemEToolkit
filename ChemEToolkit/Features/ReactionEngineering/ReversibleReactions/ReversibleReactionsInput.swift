struct ReversibleReactionsInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double
    let initialConcentrationB: Double

    let forwardFirstOrderRateConstant:
        Double
    let reverseFirstOrderRateConstant:
        Double

    let reactionTime: Double
}
