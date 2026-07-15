struct SteadyStateDiffusionInput: Equatable, Sendable {
    let diffusivity: Double
    let area: Double
    let thickness: Double
    let concentrationAtSideOne: Double
    let concentrationAtSideTwo: Double
}
