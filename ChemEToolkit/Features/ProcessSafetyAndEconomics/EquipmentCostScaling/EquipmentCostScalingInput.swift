struct EquipmentCostScalingInput:
    Equatable,
    Sendable {

    let referenceEquipmentCost:
        Double
    let referenceCapacity: Double
    let targetCapacity: Double
    let scalingExponent: Double
}
