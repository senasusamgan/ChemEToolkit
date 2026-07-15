struct DistributionCoefficientSelectivityInput:
    Equatable,
    Sendable {

    let raffinateSoluteConcentration: Double
    let extractSoluteConcentration: Double
    let raffinateImpurityConcentration: Double
    let extractImpurityConcentration: Double
}
