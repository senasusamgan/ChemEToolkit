struct SafetyProjectPortfolioRankingResult:
    Equatable,
    Sendable {

    let project1PriorityScore:
        Double
    let project2PriorityScore:
        Double
    let project3PriorityScore:
        Double

    let highestPriorityProject:
        String
    let highestPriorityScore:
        Double

    let totalPortfolioCost:
        Double
    let totalPortfolioRiskReduction:
        Double
    let portfolioRiskReductionPerCost:
        Double

    let rankingDescription:
        String

    let modelName: String
    let limitationDescription: String
}
