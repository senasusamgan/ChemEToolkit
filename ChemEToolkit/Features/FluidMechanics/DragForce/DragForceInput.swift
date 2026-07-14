struct DragForceInput:
    Equatable,
    Sendable {

    let fluidDensity: Double
    let relativeVelocity: Double
    let projectedArea: Double
    let dragCoefficient: Double
}
