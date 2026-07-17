struct LinearInterpolationCalculatorInput:
    Equatable,
    Sendable {

    let x1: Double
    let y1: Double
    let x2: Double
    let y2: Double
    let targetX: Double
}
