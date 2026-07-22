struct MIMODecouplingControlResult:
    Equatable,
    Sendable {

    let determinant: Double

    let relativeGain11: Double
    let relativeGain12: Double
    let relativeGain21: Double
    let relativeGain22: Double

    let inverseGain11: Double
    let inverseGain12: Double
    let inverseGain21: Double
    let inverseGain22: Double

    let interactionIndex: Double
    let pairingRecommendation:
        String
    let conditioningDescription:
        String

    let modelName: String
    let limitationDescription: String
}
