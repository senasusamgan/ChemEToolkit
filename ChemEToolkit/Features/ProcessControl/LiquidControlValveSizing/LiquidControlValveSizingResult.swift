struct LiquidControlValveSizingResult: Equatable, Sendable {
    let specificGravity: Double
    let requiredKvWithoutMargin: Double
    let designKv: Double
    let equivalentCv: Double
    let installedCapacityFraction: Double
    let estimatedLinearOpening: Double
    let installedValveIsAdequate: Bool
    let capacityMarginFraction: Double
    let modelName: String
    let limitationDescription: String
}
