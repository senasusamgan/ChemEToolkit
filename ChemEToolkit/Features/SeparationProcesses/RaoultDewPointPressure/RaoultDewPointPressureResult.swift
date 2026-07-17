struct RaoultDewPointPressureResult:
    Equatable,
    Sendable {

    let dewPointPressure: Double
    let liquidMoleFraction1: Double
    let liquidMoleFraction2: Double
    let inversePressureTerm1:
        Double
    let inversePressureTerm2:
        Double
    let relativeVolatility:
        Double

    let modelName: String
    let limitationDescription: String
}
