struct AxialDispersionRTDResult: Equatable, Sendable {
    let dimensionlessTime: Double
    let eValue: Double
    let dimensionlessEValue: Double
    let dimensionlessVariance: Double
    let variance: Double
    let standardDeviation: Double
    let dispersionNumber: Double
    let equivalentTanksInSeries: Double
    let modelName: String
    let limitationDescription: String
}
