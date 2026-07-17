struct IncompressibleEntropyChangeResult:
    Equatable,
    Sendable {

    let temperatureRatio: Double
    let specificEntropyChange:
        Double
    let totalEntropyChange:
        Double
    let directionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
