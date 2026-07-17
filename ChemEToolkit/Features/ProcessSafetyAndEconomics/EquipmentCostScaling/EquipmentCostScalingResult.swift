struct EquipmentCostScalingResult:
    Equatable,
    Sendable {

    let capacityRatio: Double
    let costRatio: Double

    let scaledEquipmentCost: Double

    let referenceUnitCapacityCost:
        Double
    let targetUnitCapacityCost:
        Double

    let costSavingFractionVersusLinear:
        Double

    let scalingBehaviorDescription:
        String

    let modelName: String
    let limitationDescription: String
}
