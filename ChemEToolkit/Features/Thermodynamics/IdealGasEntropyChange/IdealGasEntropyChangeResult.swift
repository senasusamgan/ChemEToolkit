struct IdealGasEntropyChangeResult:
    Equatable,
    Sendable {

    let temperatureContribution:
        Double
    let pressureContribution:
        Double
    let specificEntropyChange:
        Double
    let totalEntropyChange:
        Double
    let specificHeatAtConstantVolume:
        Double
    let directionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
