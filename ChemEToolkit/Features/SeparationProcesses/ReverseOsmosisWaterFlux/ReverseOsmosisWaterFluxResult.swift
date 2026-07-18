struct ReverseOsmosisWaterFluxResult:
    Equatable,
    Sendable {

    let netDrivingPressure: Double
    let waterFlux: Double
    let requiredMembraneArea: Double
    let requiredFeedFlow: Double
    let concentrateFlow: Double

    let modelName: String
    let limitationDescription: String
}
