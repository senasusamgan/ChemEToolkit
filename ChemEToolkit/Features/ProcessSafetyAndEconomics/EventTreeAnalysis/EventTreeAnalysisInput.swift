struct EventTreeAnalysisInput:
    Equatable,
    Sendable {

    let initiatingEventFrequency:
        Double

    let barrier1SuccessProbability:
        Double
    let barrier2SuccessProbability:
        Double
    let barrier3SuccessProbability:
        Double
}
