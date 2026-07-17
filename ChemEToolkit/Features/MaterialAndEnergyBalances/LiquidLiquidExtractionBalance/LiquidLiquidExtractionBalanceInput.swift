struct LiquidLiquidExtractionBalanceInput:
    Equatable,
    Sendable {

    let feedSolutionMass: Double
    let feedSoluteMassFraction:
        Double
    let pureSolventMass: Double
    let distributionCoefficient:
        Double
}
