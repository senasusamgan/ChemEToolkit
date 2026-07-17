struct SoluteDilutionCalculatorResult:
    Equatable,
    Sendable {

    let soluteMass: Double
    let initialSolventMass: Double

    let finalSolutionMass: Double
    let addedSolventMass: Double
    let finalSolventMass: Double

    let dilutionRatio: Double
    let addedSolventToInitialSolutionRatio:
        Double

    let modelName: String
    let limitationDescription: String
}
