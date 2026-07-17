struct VaporQualityFromEnthalpyInput:
    Equatable,
    Sendable {

    let saturatedLiquidEnthalpy:
        Double
    let saturatedVaporEnthalpy:
        Double
    let mixtureEnthalpy: Double
}
