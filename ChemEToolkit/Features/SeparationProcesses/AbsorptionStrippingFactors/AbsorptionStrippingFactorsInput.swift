struct AbsorptionStrippingFactorsInput:
    Equatable,
    Sendable {

    let liquidMolarFlow: Double
    let gasMolarFlow: Double
    let equilibriumSlope: Double
}
