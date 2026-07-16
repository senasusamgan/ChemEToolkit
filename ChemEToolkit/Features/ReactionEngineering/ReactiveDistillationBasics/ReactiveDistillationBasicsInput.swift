struct ReactiveDistillationBasicsInput:
    Equatable,
    Sendable {

    let initialMolesA: Double
    let initialMolesB: Double

    let equilibriumConstant: Double
    let productRemovalFractionPerStage:
        Double

    let numberOfStages: Double
}
