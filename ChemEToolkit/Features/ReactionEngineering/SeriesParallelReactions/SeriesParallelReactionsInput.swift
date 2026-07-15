struct SeriesParallelReactionsInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double

    let rateConstantAToB: Double
    let rateConstantBToC: Double
    let rateConstantAToD: Double

    let reactionTime: Double
}
