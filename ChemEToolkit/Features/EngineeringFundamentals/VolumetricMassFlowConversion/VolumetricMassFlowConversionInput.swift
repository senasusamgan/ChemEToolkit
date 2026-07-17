struct VolumetricMassFlowConversionInput:
    Equatable,
    Sendable {

    let volumetricFlowRateCubicMetersPerHour:
        Double
    let densityKilogramsPerCubicMeter:
        Double
}
