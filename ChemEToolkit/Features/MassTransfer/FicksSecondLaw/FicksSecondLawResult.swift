struct FicksSecondLawResult:
    Equatable,
    Sendable {

    let similarityVariable: Double
    let dimensionlessConcentrationRatio:
        Double
    let fractionalApproachToSurface:
        Double

    let concentrationAtDepthAndTime:
        Double
    let diffusionLength: Double

    let initialConcentrationGradientScale:
        Double
    let signedSurfaceFlux: Double

    let directionDescription: String
    let modelName: String
    let limitationDescription: String
}
