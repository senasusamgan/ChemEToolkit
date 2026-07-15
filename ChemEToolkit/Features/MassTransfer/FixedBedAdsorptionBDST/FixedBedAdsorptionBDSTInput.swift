struct FixedBedAdsorptionBDSTInput:
    Equatable,
    Sendable {

    let bedDepth: Double
    let columnCrossSectionalArea:
        Double
    let superficialVelocity: Double

    let influentConcentration: Double
    let breakthroughConcentration:
        Double

    let bedCapacityPerVolume: Double
    let adsorptionRateConstant: Double
}
