struct SecondOrderFrequencyResponseResult: Equatable, Sendable {
    let realPart: Double
    let imaginaryPart: Double
    let magnitude: Double
    let magnitudeDecibels: Double
    let phaseDegrees: Double
    let normalizedFrequency: Double
    let resonanceExists: Bool
    let resonanceAngularFrequency: Double?
    let resonantPeakMagnitude: Double?
    let modelName: String
    let limitationDescription: String
}
