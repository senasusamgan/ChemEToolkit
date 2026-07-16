struct CascadeControlInput: Equatable, Sendable {
    let primaryProcessGain: Double
    let secondaryProcessGain: Double

    let primaryControllerGain:
        Double
    let secondaryControllerGain:
        Double

    let primaryReferenceInput: Double
    let secondaryLoopDisturbance:
        Double
}
