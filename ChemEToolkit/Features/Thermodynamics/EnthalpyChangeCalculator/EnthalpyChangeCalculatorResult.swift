struct EnthalpyChangeCalculatorResult:
    Equatable,
    Sendable {

    let temperatureChange: Double
    let specificEnthalpyChange:
        Double
    let totalEnthalpyChange:
        Double
    let directionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
