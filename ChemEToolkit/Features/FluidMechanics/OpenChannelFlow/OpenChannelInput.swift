struct OpenChannelInput:
    Equatable,
    Sendable {

    let channelWidth: Double
    let flowDepth: Double
    let bedSlope: Double
    let manningCoefficient: Double

    init(
        channelWidth: Double,
        flowDepth: Double,
        bedSlope: Double,
        manningCoefficient: Double
    ) {
        self.channelWidth = channelWidth
        self.flowDepth = flowDepth
        self.bedSlope = bedSlope
        self.manningCoefficient =
            manningCoefficient
    }
}
