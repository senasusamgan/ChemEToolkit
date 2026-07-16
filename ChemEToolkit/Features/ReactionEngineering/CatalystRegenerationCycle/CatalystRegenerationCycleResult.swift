struct CatalystRegenerationCycleResult:
    Equatable,
    Sendable {

    let numberOfCycles: Int

    let finalActivityBeforeRegeneration:
        Double
    let finalActivityAfterRegeneration:
        Double

    let minimumActivityObserved:
        Double
    let averageOperatingActivity:
        Double

    let equivalentFullActivityOperatingTime:
        Double
    let totalCalendarOperatingTime:
        Double

    let activityAtStartOfEachCycle:
        [Double]
    let activityBeforeEachRegeneration:
        [Double]

    let modelName: String
    let limitationDescription: String
}
