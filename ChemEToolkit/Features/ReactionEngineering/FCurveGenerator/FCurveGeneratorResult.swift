struct FCurveGeneratorResult:
    Equatable,
    Sendable {

    let rawEArea: Double
    let normalizedEValues: [Double]
    let fValues: [Double]

    let timeAtTenPercent: Double
    let medianResidenceTime: Double
    let timeAtNinetyPercent: Double
    let centralEightyPercentSpan:
        Double

    let modelName: String
    let limitationDescription: String
}
