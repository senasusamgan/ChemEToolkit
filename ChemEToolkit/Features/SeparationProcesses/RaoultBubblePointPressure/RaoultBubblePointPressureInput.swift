struct RaoultBubblePointPressureInput:
    Equatable,
    Sendable {

    let liquidMoleFraction1:
        Double
    let saturationPressure1:
        Double
    let saturationPressure2:
        Double
}
