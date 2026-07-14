struct CriticalDepthInput:
    Equatable,
    Sendable {

    let volumetricFlowRate: Double
    let channelWidth: Double
    let currentFlowDepth: Double
    let gravity: Double

    init(
        volumetricFlowRate: Double,
        channelWidth: Double,
        currentFlowDepth: Double,
        gravity: Double = 9.80665
    ) {
        self.volumetricFlowRate =
            volumetricFlowRate
        self.channelWidth =
            channelWidth
        self.currentFlowDepth =
            currentFlowDepth
        self.gravity = gravity
    }
}
