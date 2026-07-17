struct CrosscurrentExtractionStagesInput:
    Equatable,
    Sendable {

    let feedCarrierFlow: Double
    let freshSolventPerStage:
        Double
    let distributionCoefficient:
        Double
    let targetRemovalFraction:
        Double
}
