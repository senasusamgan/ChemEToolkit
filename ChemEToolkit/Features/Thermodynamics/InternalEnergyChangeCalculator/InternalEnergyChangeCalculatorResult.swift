struct InternalEnergyChangeCalculatorResult:
    Equatable,
    Sendable {

    let temperatureChange: Double
    let specificInternalEnergyChange:
        Double
    let totalInternalEnergyChange:
        Double
    let directionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
