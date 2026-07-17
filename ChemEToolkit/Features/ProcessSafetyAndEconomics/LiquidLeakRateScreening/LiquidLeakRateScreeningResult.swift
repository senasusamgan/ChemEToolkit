struct LiquidLeakRateScreeningResult:
    Equatable,
    Sendable {

    let pressureDifference: Double
    let orificeArea: Double
    let idealJetVelocity: Double

    let volumetricReleaseRate:
        Double
    let massReleaseRate: Double

    let nominalInventoryReleaseTime:
        Double
    let releaseTimeMinutes:
        Double

    let modelName: String
    let limitationDescription: String
}
