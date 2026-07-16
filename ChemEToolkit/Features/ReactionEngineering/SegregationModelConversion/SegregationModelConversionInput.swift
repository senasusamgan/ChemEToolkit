struct SegregationModelConversionInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double
    let rateConstant: Double
    let reactionOrder: Double

    let times: [Double]
    let eValues: [Double]
}
