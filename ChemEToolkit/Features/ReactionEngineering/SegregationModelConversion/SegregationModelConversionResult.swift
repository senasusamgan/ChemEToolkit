struct SegregationModelConversionResult:
    Equatable,
    Sendable {

    let rawRTDArea: Double
    let meanResidenceTime: Double

    let outletConcentrationA: Double
    let conversionFraction: Double

    let batchConcentrations:
        [Double]

    let equivalentPFRConcentration:
        Double
    let equivalentPFRConversion:
        Double

    let conversionDifferenceFromPFR:
        Double

    let modelName: String
    let limitationDescription: String
}
