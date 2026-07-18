struct FixedBedAdsorberBreakthroughInput:
    Equatable,
    Sendable {

    let bedDepth: Double
    let bedCapacityDensity:
        Double
    let inletConcentration:
        Double
    let superficialVelocity:
        Double
    let kineticConstant:
        Double
    let breakthroughFraction:
        Double
}
