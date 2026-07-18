struct HydrocycloneSeparationNumberResult: Equatable, Sendable {
    let radialSettlingVelocity: Double
    let centrifugalAcceleration: Double
    let centrifugalGForce: Double
    let separationNumber: Double
    let particleRelaxationTime: Double
    let modelName: String
    let limitationDescription: String
}
