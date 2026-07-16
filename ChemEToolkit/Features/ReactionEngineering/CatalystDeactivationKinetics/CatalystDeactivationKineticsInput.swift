struct CatalystDeactivationKineticsInput:
    Equatable,
    Sendable {

    let initialActivity: Double
    let deactivationRateConstant:
        Double
    let deactivationOrder: Double

    let elapsedTime: Double
    let targetActivity: Double
}
