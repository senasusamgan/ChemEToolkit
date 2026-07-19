struct CoupledODESystemRK4Input: Equatable, Sendable {
    let a11: Double
    let a12: Double
    let a21: Double
    let a22: Double
    let initialX: Double
    let initialY: Double
    let finalTime: Double
    let stepSize: Double
}
