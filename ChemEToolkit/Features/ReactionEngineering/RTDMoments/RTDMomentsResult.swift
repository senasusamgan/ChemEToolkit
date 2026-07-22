struct RTDMomentsResult: Equatable, Sendable {
    let tracerArea: Double
    let meanResidenceTime: Double
    let variance: Double
    let standardDeviation: Double
    let coefficientOfVariation: Double
    let dimensionlessVariance: Double
    let equivalentTanksInSeries: Double
    let modelName: String
    let limitationDescription: String
}
