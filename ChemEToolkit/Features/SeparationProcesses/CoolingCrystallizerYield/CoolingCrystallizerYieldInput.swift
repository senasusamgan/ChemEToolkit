struct CoolingCrystallizerYieldInput:
    Equatable,
    Sendable {

    let solventMass: Double
    let hotSolubility: Double
    let coldSolubility: Double
    let crystalPurityFraction: Double
}
