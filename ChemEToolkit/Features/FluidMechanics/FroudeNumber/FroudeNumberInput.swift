struct FroudeNumberInput:
    Equatable,
    Sendable {

    let averageVelocity: Double
    let hydraulicDepth: Double
    let gravity: Double

    init(
        averageVelocity: Double,
        hydraulicDepth: Double,
        gravity: Double = 9.80665
    ) {
        self.averageVelocity =
            averageVelocity
        self.hydraulicDepth =
            hydraulicDepth
        self.gravity = gravity
    }
}
