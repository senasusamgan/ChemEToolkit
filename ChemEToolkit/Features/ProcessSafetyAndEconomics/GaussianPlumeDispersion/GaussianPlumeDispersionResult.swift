struct GaussianPlumeDispersionResult:
    Equatable,
    Sendable {

    let crosswindAttenuation:
        Double
    let directVerticalTerm:
        Double
    let reflectedVerticalTerm:
        Double

    let receptorConcentration:
        Double
    let receptorConcentrationMilligramsPerCubicMeter:
        Double

    let groundCenterlineConcentration:
        Double
    let relativeToGroundCenterline:
        Double

    let modelName: String
    let limitationDescription: String
}
