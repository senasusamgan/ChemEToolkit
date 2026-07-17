struct BinaryDistillationBalanceResult:
    Equatable,
    Sendable {

    let distillateMolarFlow:
        Double
    let bottomsMolarFlow: Double

    let lightComponentFeedFlow:
        Double
    let lightComponentDistillateFlow:
        Double
    let lightComponentBottomsFlow:
        Double

    let lightRecoveryToDistillate:
        Double
    let distillateFractionOfFeed:
        Double

    let modelName: String
    let limitationDescription: String
}
