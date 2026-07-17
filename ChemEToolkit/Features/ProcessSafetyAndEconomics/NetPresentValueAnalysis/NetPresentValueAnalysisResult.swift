struct NetPresentValueAnalysisResult:
    Equatable,
    Sendable {

    let projectLifeYears: Int

    let presentValueOfAnnualCashFlows:
        Double
    let presentValueOfTerminalValue:
        Double

    let netPresentValue: Double
    let profitabilityIndex: Double

    let discountedPaybackYears:
        Double?

    let valueCreationDescription:
        String

    let modelName: String
    let limitationDescription: String
}
