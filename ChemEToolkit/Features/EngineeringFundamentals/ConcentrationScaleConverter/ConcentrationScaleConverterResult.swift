struct ConcentrationScaleConverterResult:
    Equatable,
    Sendable {

    let inputScaleName: String
    let dimensionlessFraction:
        Double
    let percent: Double
    let partsPerMillion: Double
    let partsPerBillion: Double

    let modelName: String
    let limitationDescription: String
}
