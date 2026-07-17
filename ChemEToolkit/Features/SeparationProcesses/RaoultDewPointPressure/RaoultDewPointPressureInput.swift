struct RaoultDewPointPressureInput:
    Equatable,
    Sendable {

    let vaporMoleFraction1:
        Double
    let saturationPressure1:
        Double
    let saturationPressure2:
        Double
}
