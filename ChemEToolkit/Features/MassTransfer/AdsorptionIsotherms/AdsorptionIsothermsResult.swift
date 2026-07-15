struct AdsorptionIsothermsResult:
    Equatable,
    Sendable {

    let model: AdsorptionIsothermModel
    let equilibriumLoading: Double
    let localIsothermSlope: Double
    let fractionalSaturation: Double?
    let activeEquation: String
    let parameterInterpretation: String
    let modelName: String
}
