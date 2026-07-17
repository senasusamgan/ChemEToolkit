struct EmergencyVentilationDilutionResult:
    Equatable,
    Sendable {

    let airChangesPerHour: Double
    let dilutionTimeConstant:
        Double
    let concentrationAfterElapsedTime:
        Double

    let timeToTargetConcentration:
        Double
    let removalFractionAfterElapsedTime:
        Double
    let targetReachedWithinElapsedTime:
        Bool

    let modelName: String
    let limitationDescription: String
}
