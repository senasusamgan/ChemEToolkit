struct CatalystWeightFromRateDataResult:
    Equatable,
    Sendable {

    let conversionInterval: Double
    let midpointConversion: Double

    let catalystLevenspielArea:
        Double
    let requiredCatalystWeight:
        Double

    let averageInverseRate:
        Double
    let averageMassSpecificRate:
        Double

    let catalystWeightPerFeedMolarRate:
        Double

    let modelName: String
    let limitationDescription: String
}
