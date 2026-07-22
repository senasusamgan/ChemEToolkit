struct ConversionFromRTDResult: Equatable, Sendable {
    let rawRTDArea: Double
    let meanResidenceTime: Double
    let outletUnreactedFraction: Double
    let conversionFraction: Double
    let idealPFRConversion: Double
    let idealCSTRConversion: Double
    let modelName: String
    let limitationDescription: String
}
