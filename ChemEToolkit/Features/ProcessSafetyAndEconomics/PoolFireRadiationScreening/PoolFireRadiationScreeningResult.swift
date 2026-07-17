struct PoolFireRadiationScreeningResult:
    Equatable,
    Sendable {

    let totalHeatReleaseRate:
        Double
    let radiatedHeatRate: Double
    let transmittedRadiatedHeatRate:
        Double
    let thermalRadiationFlux:
        Double

    let hazardBand: String
    let screeningDescription:
        String

    let modelName: String
    let limitationDescription: String
}
