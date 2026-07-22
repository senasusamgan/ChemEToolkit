struct MethodOfLinesPDESolverResult: Equatable, Sendable {
    let positions: [Double]
    let concentrations: [Double]
    let spatialStep: Double
    let timeStep: Double
    let diffusionNumber: Double
    let reactionNumber: Double
}
