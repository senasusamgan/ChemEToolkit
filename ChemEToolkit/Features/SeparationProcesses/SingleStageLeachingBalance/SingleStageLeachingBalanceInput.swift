struct SingleStageLeachingBalanceInput:
    Equatable,
    Sendable {

    let drySolidMass: Double
    let initialSoluteOnSolid: Double
    let solventMass: Double
    let leachingDistributionCoefficient: Double
    let solventRetentionPerDrySolid: Double
}
