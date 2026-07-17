struct SafetyProjectPortfolioRankingInput:
    Equatable,
    Sendable {

    let project1RiskReduction:
        Double
    let project1Cost: Double
    let project1UrgencyRating:
        Double

    let project2RiskReduction:
        Double
    let project2Cost: Double
    let project2UrgencyRating:
        Double

    let project3RiskReduction:
        Double
    let project3Cost: Double
    let project3UrgencyRating:
        Double
}
