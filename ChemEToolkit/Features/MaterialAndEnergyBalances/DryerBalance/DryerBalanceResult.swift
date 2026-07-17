struct DryerBalanceResult:
    Equatable,
    Sendable {

    let drySolidFlow: Double
    let initialWaterFlow: Double

    let driedProductFlow: Double
    let finalWaterFlow: Double
    let waterRemovedFlow: Double

    let initialMoistureDryBasis:
        Double
    let finalMoistureDryBasis:
        Double
    let waterRemovalFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
