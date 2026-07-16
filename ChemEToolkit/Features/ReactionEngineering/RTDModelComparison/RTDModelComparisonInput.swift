struct RTDModelComparisonInput:
    Equatable,
    Sendable {

    let meanResidenceTime: Double
    let residenceTimeVariance: Double
    let firstOrderRateConstant: Double
}
