struct SolidsWashingBalanceInput:
    Equatable,
    Sendable {

    let initialRetainedSolutionMass:
        Double
    let initialSoluteMassFraction:
        Double
    let washSolventMass: Double
    let finalRetainedSolutionMass:
        Double
}
