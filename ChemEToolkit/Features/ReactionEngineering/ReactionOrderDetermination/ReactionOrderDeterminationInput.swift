struct ReactionOrderDeterminationInput:
    Equatable,
    Sendable {

    let concentrationExperimentOne: Double
    let rateExperimentOne: Double
    let concentrationExperimentTwo: Double
    let rateExperimentTwo: Double
}
