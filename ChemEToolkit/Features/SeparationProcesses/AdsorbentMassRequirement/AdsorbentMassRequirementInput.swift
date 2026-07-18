struct AdsorbentMassRequirementInput:
    Equatable,
    Sendable {

    let soluteFeedRate:
        Double
    let cycleTime:
        Double
    let equilibriumCapacity:
        Double
    let utilizationFraction:
        Double
    let safetyFactor:
        Double
}
