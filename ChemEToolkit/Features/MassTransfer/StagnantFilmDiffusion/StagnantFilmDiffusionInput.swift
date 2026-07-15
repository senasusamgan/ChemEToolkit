struct StagnantFilmDiffusionInput: Equatable, Sendable {
    let diffusivity: Double
    let totalPressure: Double
    let temperature: Double
    let thickness: Double
    let moleFractionAAtSideOne: Double
    let moleFractionAAtSideTwo: Double
}
