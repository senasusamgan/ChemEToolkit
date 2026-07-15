struct SteadyStateDiffusionResult: Equatable, Sendable {
    let molarFlux: Double
    let molarRate: Double
    let midpointConcentration: Double
}
