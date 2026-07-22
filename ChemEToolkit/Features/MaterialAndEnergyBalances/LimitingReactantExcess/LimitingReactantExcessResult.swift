struct LimitingReactantExcessResult:
    Equatable,
    Sendable {

    let limitingReactant: String
    let maximumReactionExtent:
        Double

    let amountAConsumed: Double
    let amountBConsumed: Double
    let amountARemaining: Double
    let amountBRemaining: Double

    let excessReactant: String
    let percentExcess: Double

    let modelName: String
    let limitationDescription: String
}
