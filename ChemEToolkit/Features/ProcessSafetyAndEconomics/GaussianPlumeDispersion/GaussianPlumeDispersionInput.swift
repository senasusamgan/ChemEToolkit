struct GaussianPlumeDispersionInput:
    Equatable,
    Sendable {

    let sourceEmissionRate:
        Double
    let windSpeed: Double
    let crosswindDistance: Double
    let receptorHeight: Double
    let effectiveReleaseHeight:
        Double
    let horizontalDispersionCoefficient:
        Double
    let verticalDispersionCoefficient:
        Double
}
