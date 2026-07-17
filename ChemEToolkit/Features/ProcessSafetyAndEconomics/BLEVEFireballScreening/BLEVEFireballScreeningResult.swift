struct BLEVEFireballScreeningResult:
    Equatable,
    Sendable {

    let fireballDiameter: Double
    let fireballDuration: Double

    let totalCombustionEnergy:
        Double
    let radiatedEnergy: Double
    let averageRadiationFlux:
        Double

    let hazardBand: String
    let screeningDescription:
        String

    let modelName: String
    let limitationDescription: String
}
