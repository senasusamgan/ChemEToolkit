struct SaturatedMixturePropertyInput:
    Equatable,
    Sendable {

    let saturatedLiquidProperty:
        Double
    let saturatedVaporProperty:
        Double
    let vaporQuality: Double
}
