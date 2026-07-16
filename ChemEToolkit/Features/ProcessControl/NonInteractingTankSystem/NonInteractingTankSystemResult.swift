struct NonInteractingTankSystemResult:
    Equatable,
    Sendable {

    let firstTankTimeConstant:
        Double
    let secondTankTimeConstant:
        Double

    let firstTankLevelChange:
        Double
    let secondTankLevelChange:
        Double

    let finalFirstTankLevelChange:
        Double
    let finalSecondTankLevelChange:
        Double

    let normalizedOutletResponse:
        Double
    let combinedMeanResidenceTime:
        Double

    let equalTimeConstants:
        Bool

    let modelName: String
    let limitationDescription: String
}
