struct LiquidReliefValveSizingResult:
    Equatable,
    Sendable {

    let pressureDifference: Double
    let requiredVolumetricFlowRate:
        Double
    let idealJetVelocity: Double

    let requiredFlowArea:
        Double
    let equivalentOrificeDiameter:
        Double

    let areaPerMassFlowRate:
        Double

    let modelName: String
    let limitationDescription: String
}
