struct EquivalentAnnualWorthResult:
    Equatable,
    Sendable {

    let projectLifeYears: Int

    let capitalRecoveryFactor:
        Double
    let sinkingFundFactor: Double

    let annualizedInitialInvestment:
        Double
    let annualizedTerminalValue:
        Double

    let equivalentAnnualWorth:
        Double

    let presentWorth: Double
    let economicDescription:
        String

    let modelName: String
    let limitationDescription: String
}
