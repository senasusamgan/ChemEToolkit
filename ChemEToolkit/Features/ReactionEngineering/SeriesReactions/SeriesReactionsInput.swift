struct SeriesReactionsInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double
    let firstStepRateConstant: Double
    let secondStepRateConstant: Double
    let reactionTime: Double
}
