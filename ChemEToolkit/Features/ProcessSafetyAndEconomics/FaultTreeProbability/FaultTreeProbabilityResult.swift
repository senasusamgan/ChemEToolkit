struct FaultTreeProbabilityResult:
    Equatable,
    Sendable {

    let gateName: String

    let topEventProbability:
        Double
    let topEventComplement:
        Double

    let sumOfBasicProbabilities:
        Double
    let productOfBasicProbabilities:
        Double

    let rareEventApproximation:
        Double
    let approximationError:
        Double

    let dominantBasicEvent:
        String
    let gateDescription: String

    let modelName: String
    let limitationDescription: String
}
