struct FicksSecondLawInput:
    Equatable,
    Sendable {

    let initialConcentration: Double
    let surfaceConcentration: Double

    let diffusivity: Double
    let depth: Double
    let diffusionTime: Double
}
