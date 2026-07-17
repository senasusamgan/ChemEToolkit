struct SoluteDilutionCalculatorInput:
    Equatable,
    Sendable {

    let initialSolutionMass: Double
    let initialSoluteMassFraction:
        Double
    let targetSoluteMassFraction:
        Double
}
