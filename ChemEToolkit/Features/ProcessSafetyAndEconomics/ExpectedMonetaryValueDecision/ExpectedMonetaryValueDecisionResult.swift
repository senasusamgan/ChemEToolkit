struct ExpectedMonetaryValueDecisionResult:
    Equatable,
    Sendable {

    let optionAExpectedOutcome: Double
    let optionBExpectedOutcome: Double

    let optionANetExpectedValue: Double
    let optionBNetExpectedValue: Double

    let expectedValueDifference:
        Double
    let preferredOption: String
    let indifferenceThresholdMet:
        Bool
    let decisionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
