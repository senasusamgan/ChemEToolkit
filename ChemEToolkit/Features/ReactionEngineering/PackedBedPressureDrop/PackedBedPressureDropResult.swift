struct PackedBedPressureDropResult:
    Equatable,
    Sendable {

    let viscousPressureGradient: Double
    let inertialPressureGradient: Double
    let totalPressureGradient: Double

    let viscousPressureDrop: Double
    let inertialPressureDrop: Double
    let totalPressureDrop: Double

    let particleReynoldsNumber: Double

    let viscousContributionFraction:
        Double
    let inertialContributionFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
