struct RichardsonErrorEstimateInput: Equatable, Sendable {
    let coarseResult: Double
    let fineResult: Double
    let refinementRatio: Double
    let methodOrder: Double
}
