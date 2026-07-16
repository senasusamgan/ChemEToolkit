struct ZieglerNicholsReactionCurveTuningInput:
    Equatable,
    Sendable {

    let processGain: Double
    let processTimeConstant:
        Double
    let processDeadTime: Double
}
