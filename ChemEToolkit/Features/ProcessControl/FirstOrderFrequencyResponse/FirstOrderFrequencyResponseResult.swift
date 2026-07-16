struct FirstOrderFrequencyResponseResult: Equatable, Sendable {
    let realPart: Double
    let imaginaryPart: Double
    let magnitude: Double
    let magnitudeDecibels: Double
    let phaseRadians: Double
    let phaseDegrees: Double
    let cutoffAngularFrequency: Double
    let normalizedFrequency: Double
    let modelName: String
    let limitationDescription: String
}
