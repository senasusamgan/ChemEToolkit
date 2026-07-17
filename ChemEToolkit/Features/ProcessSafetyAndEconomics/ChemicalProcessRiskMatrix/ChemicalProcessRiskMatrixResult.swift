struct ChemicalProcessRiskMatrixResult:
    Equatable,
    Sendable {

    let likelihoodRating: Int
    let severityRating: Int

    let inherentRiskScore: Int
    let safeguardCredit: Int
    let residualRiskScore: Int

    let inherentRiskBand: String
    let residualRiskBand: String

    let actionPriority:
        String
    let riskReductionFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
