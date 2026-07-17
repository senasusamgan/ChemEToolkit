struct CostIndexEscalationResult:
    Equatable,
    Sendable {

    let costIndexRatio: Double
    let escalatedCost: Double
    let absoluteCostChange: Double

    let totalEscalationFraction:
        Double
    let compoundAnnualEscalationRate:
        Double

    let directionDescription:
        String

    let modelName: String
    let limitationDescription: String
}
