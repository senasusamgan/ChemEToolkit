struct VaporQualityFromEnthalpyResult:
    Equatable,
    Sendable {

    let latentEnthalpy: Double
    let vaporQuality: Double
    let liquidMassFraction: Double
    let vaporMassFraction: Double
    let regionDescription: String

    let modelName: String
    let limitationDescription: String
}
