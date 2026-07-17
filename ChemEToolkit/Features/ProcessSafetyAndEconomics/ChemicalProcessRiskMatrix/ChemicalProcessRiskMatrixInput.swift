struct ChemicalProcessRiskMatrixInput:
    Equatable,
    Sendable {

    let likelihoodRating: Double
    let severityRating: Double

    let existingSafeguardCredit:
        Double
}
