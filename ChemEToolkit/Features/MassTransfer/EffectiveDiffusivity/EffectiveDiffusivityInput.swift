struct EffectiveDiffusivityInput:
    Equatable,
    Sendable {

    let molecularDiffusivity: Double
    let knudsenDiffusivity: Double

    let porosity: Double
    let tortuosity: Double
    let constrictivity: Double
}
