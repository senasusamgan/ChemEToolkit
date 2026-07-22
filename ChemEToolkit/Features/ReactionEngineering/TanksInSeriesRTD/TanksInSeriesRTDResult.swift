struct TanksInSeriesRTDResult: Equatable, Sendable {
    let numberOfTanks: Int
    let dimensionlessTime: Double
    let eValue: Double
    let dimensionlessVariance: Double
    let variance: Double
    let standardDeviation: Double
    let peakTime: Double
    let modelName: String
    let limitationDescription: String
}
