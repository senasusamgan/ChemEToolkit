struct SecondOrderFrequencyResponseInput: Equatable, Sendable {
    let processGain: Double
    let naturalFrequency: Double
    let dampingRatio: Double
    let angularFrequency: Double
}
