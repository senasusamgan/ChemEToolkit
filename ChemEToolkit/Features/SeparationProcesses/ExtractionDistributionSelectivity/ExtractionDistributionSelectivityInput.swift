struct ExtractionDistributionSelectivityInput:
    Equatable,
    Sendable {

    let feedCarrierFlow: Double
    let solventCarrierFlow: Double

    let targetDistributionCoefficient:
        Double
    let impurityDistributionCoefficient:
        Double
}
