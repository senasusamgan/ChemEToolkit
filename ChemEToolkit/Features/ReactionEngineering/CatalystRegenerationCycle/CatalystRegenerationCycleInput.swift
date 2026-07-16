struct CatalystRegenerationCycleInput:
    Equatable,
    Sendable {

    let initialActivity: Double
    let deactivationRateConstant:
        Double
    let operatingTimePerCycle:
        Double

    let regenerationRecoveryFraction:
        Double
    let numberOfCycles: Double
}
