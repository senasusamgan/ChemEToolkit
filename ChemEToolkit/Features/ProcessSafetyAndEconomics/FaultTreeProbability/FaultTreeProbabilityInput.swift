struct FaultTreeProbabilityInput:
    Equatable,
    Sendable {

    let basicEvent1Probability:
        Double
    let basicEvent2Probability:
        Double
    let basicEvent3Probability:
        Double

    let gateCode: Double
}
