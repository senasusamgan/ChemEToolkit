struct ExpectedMonetaryValueDecisionInput:
    Equatable,
    Sendable {

    let optionAInitialCost: Double
    let optionASuccessProbability:
        Double
    let optionASuccessValue: Double
    let optionAFailureValue: Double

    let optionBInitialCost: Double
    let optionBSuccessProbability:
        Double
    let optionBSuccessValue: Double
    let optionBFailureValue: Double
}
