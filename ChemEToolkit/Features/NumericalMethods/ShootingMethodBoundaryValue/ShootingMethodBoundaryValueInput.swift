struct ShootingMethodBoundaryValueInput: Equatable, Sendable {
    let coefficientK: Double
    let initialX: Double
    let finalX: Double
    let initialY: Double
    let targetFinalY: Double
    let initialSlopeGuessOne: Double
    let initialSlopeGuessTwo: Double
    let stepSize: Double
    let tolerance: Double
    let maximumIterations: Double
}
