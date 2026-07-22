struct PhaseChangeEnergyBalanceResult:
    Equatable,
    Sendable {

    let transformedMassFlow:
        Double
    let untransformedMassFlow:
        Double
    let heatDuty: Double
    let specificDutyOnFeedBasis:
        Double

    let modelName: String
    let limitationDescription: String
}
