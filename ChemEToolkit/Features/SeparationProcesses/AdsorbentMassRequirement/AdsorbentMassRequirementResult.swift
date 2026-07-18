struct AdsorbentMassRequirementResult:
    Equatable,
    Sendable {

    let solutePerCycle:
        Double
    let workingCapacity:
        Double
    let theoreticalAdsorbentMass:
        Double
    let designAdsorbentMass:
        Double
    let unusedCapacityFraction:
        Double

    let modelName: String
    let limitationDescription:
        String
}
