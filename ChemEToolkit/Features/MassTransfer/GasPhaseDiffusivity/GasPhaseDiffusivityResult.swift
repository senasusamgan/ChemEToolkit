struct GasPhaseDiffusivityResult:
    Equatable,
    Sendable {

    let targetDiffusivity: Double
    let temperatureCorrectionFactor: Double
    let pressureCorrectionFactor: Double
    let totalCorrectionFactor: Double
    let modelName: String
}
