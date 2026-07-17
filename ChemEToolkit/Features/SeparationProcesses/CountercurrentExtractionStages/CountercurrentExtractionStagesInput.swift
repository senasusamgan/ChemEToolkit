struct CountercurrentExtractionStagesInput:
    Equatable,
    Sendable {

    let feedCarrierFlow: Double
    let solventCarrierFlow: Double
    let distributionCoefficient:
        Double
    let targetRemovalFraction:
        Double
}
