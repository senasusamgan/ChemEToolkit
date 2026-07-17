struct GasLeakRateScreeningResult:
    Equatable,
    Sendable {

    let orificeArea: Double
    let specificGasConstant:
        Double
    let upstreamGasDensity:
        Double

    let pressureRatio: Double
    let criticalPressureRatio:
        Double
    let flowIsChoked: Bool

    let massFlux: Double
    let massReleaseRate: Double
    let upstreamVolumetricReleaseRate:
        Double

    let flowRegimeDescription:
        String

    let modelName: String
    let limitationDescription: String
}
