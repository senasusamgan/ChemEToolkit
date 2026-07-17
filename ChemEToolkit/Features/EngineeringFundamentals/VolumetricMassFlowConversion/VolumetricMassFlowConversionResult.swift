struct VolumetricMassFlowConversionResult:
    Equatable,
    Sendable {

    let massFlowRateKilogramsPerHour:
        Double
    let massFlowRateKilogramsPerSecond:
        Double
    let volumetricFlowRateCubicMetersPerSecond:
        Double
    let volumetricFlowRateLitersPerSecond:
        Double

    let modelName: String
    let limitationDescription: String
}
