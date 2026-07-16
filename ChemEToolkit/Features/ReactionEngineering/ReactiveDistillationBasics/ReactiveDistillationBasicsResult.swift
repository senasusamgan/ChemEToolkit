struct ReactiveDistillationBasicsResult:
    Equatable,
    Sendable {

    let numberOfStages: Int

    let finalMolesA: Double
    let retainedMolesB: Double
    let removedMolesB: Double

    let conversionOfInitialA: Double
    let equilibriumOnlyConversion:
        Double
    let conversionEnhancement:
        Double

    let productRecoveryFraction:
        Double
    let massBalanceClosure:
        Double

    let modelName: String
    let limitationDescription: String
}
