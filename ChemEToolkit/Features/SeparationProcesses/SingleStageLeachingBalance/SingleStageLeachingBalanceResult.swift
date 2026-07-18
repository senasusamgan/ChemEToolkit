struct SingleStageLeachingBalanceResult:
    Equatable,
    Sendable {

    let initialSoluteMass: Double
    let extractedSoluteMass: Double
    let retainedSoluteMass: Double
    let extractionFraction: Double
    let freeExtractSolutionMass: Double
    let retainedSolutionMass: Double

    let modelName: String
    let limitationDescription: String
}
