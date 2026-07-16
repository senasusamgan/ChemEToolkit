struct CatalystDeactivationKineticsResult:
    Equatable,
    Sendable {

    let currentActivity: Double
    let retainedActivityPercent:
        Double
    let lostActivityFraction: Double

    let timeToTargetActivity: Double
    let timeToHalfInitialActivity:
        Double

    let targetAlreadyPassed: Bool
    let finiteExtinctionTime: Double?

    let modelName: String
    let limitationDescription: String
}
