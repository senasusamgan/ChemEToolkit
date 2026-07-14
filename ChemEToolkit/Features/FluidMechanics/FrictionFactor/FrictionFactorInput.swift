struct FrictionFactorInput:
    Equatable,
    Sendable {

    let reynoldsNumber: Double
    let pipeDiameter: Double
    let absoluteRoughness: Double
    let tolerance: Double
    let maximumIterations: Int

    init(
        reynoldsNumber: Double,
        pipeDiameter: Double,
        absoluteRoughness: Double,
        tolerance: Double = 1e-10,
        maximumIterations: Int = 100
    ) {
        self.reynoldsNumber =
            reynoldsNumber
        self.pipeDiameter =
            pipeDiameter
        self.absoluteRoughness =
            absoluteRoughness
        self.tolerance =
            tolerance
        self.maximumIterations =
            maximumIterations
    }
}
