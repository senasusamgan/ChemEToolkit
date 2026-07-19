struct CoupledODESystemRK4Result: Equatable, Sendable {
    let finalX: Double
    let finalY: Double
    let finalMagnitude: Double
    let stepCount: Double
    let finalTime: Double
    let modelName: String
    let limitationDescription: String
}
