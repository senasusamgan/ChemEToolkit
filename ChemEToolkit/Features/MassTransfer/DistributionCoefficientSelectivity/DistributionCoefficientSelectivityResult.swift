struct DistributionCoefficientSelectivityResult:
    Equatable,
    Sendable {

    let soluteDistributionCoefficient: Double
    let impurityDistributionCoefficient: Double
    let separationFactor: Double
    let solutePreferenceDescription: String
    let selectivityDescription: String
    let modelName: String
}
