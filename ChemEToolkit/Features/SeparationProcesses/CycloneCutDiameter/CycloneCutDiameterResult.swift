struct CycloneCutDiameterResult: Equatable, Sendable {
    let cutDiameter: Double
    let densityDifference: Double
    let centrifugalExposure: Double
    let particleRelaxationTime: Double
    let modelName: String
    let limitationDescription: String
}
