struct EquilibriumConversionResult:
    Equatable,
    Sendable {

    let totalConcentration: Double

    let equilibriumConcentrationA: Double
    let equilibriumConcentrationB: Double

    let signedExtentConcentration: Double
    let signedExtentFractionOfTotal:
        Double

    let forwardConversionOfInitialA:
        Double
    let reverseConversionOfInitialB:
        Double

    let initialReactionQuotient: Double
    let equilibriumReactionQuotient:
        Double

    let directionDescription: String
    let modelName: String
    let limitationDescription: String
}
