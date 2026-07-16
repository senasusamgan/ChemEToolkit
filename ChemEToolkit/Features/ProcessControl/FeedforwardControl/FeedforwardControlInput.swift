struct FeedforwardControlInput: Equatable, Sendable {
    let manipulatedPathGain: Double
    let disturbancePathGain: Double
    let measuredDisturbanceChange: Double

    let controllerBias: Double
    let minimumControllerOutput: Double
    let maximumControllerOutput: Double
}
