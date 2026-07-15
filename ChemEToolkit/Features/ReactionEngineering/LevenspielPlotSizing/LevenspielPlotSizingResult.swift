struct LevenspielPlotSizingResult:
    Equatable,
    Sendable {

    let conversionInterval: Double
    let midpointConversion: Double

    let pfrLevenspielArea: Double
    let pfrVolume: Double

    let cstrLevenspielArea: Double
    let cstrVolume: Double

    let cstrToPFRVolumeRatio: Double
    let volumeDifference: Double
    let percentVolumeSavingWithPFR:
        Double

    let simpsonAverageInverseRate:
        Double

    let comparisonDescription: String
    let modelName: String
    let limitationDescription: String
}
