struct MassFractionCalculatorResult:
    Equatable,
    Sendable {

    let totalMass: Double
    let componentMassFraction:
        Double
    let otherMassFraction: Double
    let componentMassPercent:
        Double

    let modelName: String
    let limitationDescription: String
}
