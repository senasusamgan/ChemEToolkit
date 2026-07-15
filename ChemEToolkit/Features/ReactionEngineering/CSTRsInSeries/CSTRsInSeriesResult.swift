struct CSTRsInSeriesResult:
    Equatable,
    Sendable {

    let numberOfReactors: Int
    let totalSpaceTime: Double
    let spaceTimePerReactor: Double
    let damkohlerNumberPerReactor: Double

    let conversionForSeries: Double
    let conversionForSingleCSTR: Double
    let conversionForPFR: Double

    let seriesGainOverSingleCSTR: Double
    let remainingGapToPFR: Double
    let outletConcentrationFraction: Double

    let modelName: String
    let limitationDescription: String
}
