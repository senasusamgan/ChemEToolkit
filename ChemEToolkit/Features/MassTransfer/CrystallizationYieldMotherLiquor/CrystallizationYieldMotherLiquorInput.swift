struct CrystallizationYieldMotherLiquorInput:
    Equatable,
    Sendable {

    let feedSolutionMass: Double
    let feedSoluteMassFraction: Double

    let evaporatedSolventMass: Double
    let finalSolubilityRatio: Double

    let crystalSoluteMassFraction:
        Double
}
