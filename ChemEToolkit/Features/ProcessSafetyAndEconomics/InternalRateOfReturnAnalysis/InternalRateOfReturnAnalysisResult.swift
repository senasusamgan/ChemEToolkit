struct InternalRateOfReturnAnalysisResult:
    Equatable,
    Sendable {

    let projectLifeYears: Int

    let internalRateOfReturn:
        Double
    let netPresentValueAtIRR:
        Double

    let lowerBracketRate: Double
    let upperBracketRate: Double

    let iterationCount: Int
    let annualCashFlowToInvestmentRatio:
        Double

    let resultDescription: String

    let modelName: String
    let limitationDescription: String
}
