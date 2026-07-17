struct ToxicExposureDoseScreeningResult:
    Equatable,
    Sendable {

    let calculatedDose: Double
    let doseRatio: Double

    let maximumDurationAtCurrentConcentration:
        Double
    let maximumConcentrationAtCurrentDuration:
        Double

    let targetExceeded: Bool
    let exposureBand: String
    let screeningDescription:
        String

    let modelName: String
    let limitationDescription: String
}
