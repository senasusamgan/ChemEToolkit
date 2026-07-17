struct ExtractionSolventRequirementInput:
    Equatable,
    Sendable {

    let feedCarrierFlow: Double
    let feedSoluteFraction:
        Double
    let distributionCoefficient:
        Double
    let targetRemovalFraction:
        Double
}
