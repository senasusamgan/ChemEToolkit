struct LiquidPhaseDiffusivityResult:
    Equatable,
    Sendable {

    let targetDiffusivity: Double
    let temperatureCorrectionFactor: Double
    let viscosityCorrectionFactor: Double
    let totalCorrectionFactor: Double
    let modelName: String
}
