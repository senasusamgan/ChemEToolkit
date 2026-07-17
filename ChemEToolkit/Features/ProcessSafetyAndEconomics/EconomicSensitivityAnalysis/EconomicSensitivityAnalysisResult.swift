struct EconomicSensitivityAnalysisResult:
    Equatable,
    Sendable {

    let projectLifeYears: Int

    let baseAnnualNetCashFlow:
        Double
    let scenarioAnnualNetCashFlow:
        Double

    let baseNetPresentValue:
        Double
    let scenarioNetPresentValue:
        Double

    let netPresentValueChange:
        Double
    let netPresentValueChangeFraction:
        Double?

    let baseSimplePaybackYears:
        Double?
    let scenarioSimplePaybackYears:
        Double?

    let dominantSensitivityDriver:
        String
    let scenarioDescription: String

    let modelName: String
    let limitationDescription: String
}
