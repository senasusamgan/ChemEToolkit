struct MoleFractionCalculatorResult:
    Equatable,
    Sendable {

    let totalMoles: Double
    let componentMoleFraction:
        Double
    let otherMoleFraction: Double
    let componentMolePercent:
        Double

    let modelName: String
    let limitationDescription: String
}
