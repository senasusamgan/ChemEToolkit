struct BatchSettlingAreaEstimateResult:
    Equatable,
    Sendable {

    let theoreticalArea: Double
    let designArea: Double
    let equivalentDiameter: Double
    let liquidDepth: Double
    let designVolume: Double

    let modelName: String
    let limitationDescription: String
}
