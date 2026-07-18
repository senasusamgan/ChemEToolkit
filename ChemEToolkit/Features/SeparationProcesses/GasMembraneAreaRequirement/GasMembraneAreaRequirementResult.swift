struct GasMembraneAreaRequirementResult:
    Equatable,
    Sendable {

    let effectiveDrivingPressure: Double
    let idealComponentFlux: Double
    let utilizedComponentFlux: Double
    let requiredMembraneArea: Double

    let modelName: String
    let limitationDescription: String
}
