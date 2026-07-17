struct AnnualizedLossExpectancyInput:
    Equatable,
    Sendable {

    let eventFrequencyPerYear: Double
    let assetDamageCost: Double
    let businessInterruptionCost: Double
    let environmentalRemediationCost: Double
    let injuryAndLiabilityCost: Double
    let insuranceRecoveryFraction: Double
}
