struct SpaceTimeSpaceVelocityResult:
    Equatable,
    Sendable {

    let spaceTimeSeconds: Double
    let spaceTimeMinutes: Double
    let spaceTimeHours: Double

    let spaceVelocityPerSecond: Double
    let spaceVelocityPerHour: Double

    let fluidHoldupVolume: Double
    let fluidHoldupResidenceTimeSeconds:
        Double
    let interstitialSpaceVelocityPerHour:
        Double

    let reactorVolumesProcessedPerDay:
        Double
    let dailyVolumetricThroughput: Double

    let modelName: String
    let limitationDescription: String
}
