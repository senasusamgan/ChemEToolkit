import Testing
@testable import ChemEToolkit

@Suite("Safety Project Portfolio Ranking Engine")
struct SafetyProjectPortfolioRankingEngineTests {
    private let engine =
        SafetyProjectPortfolioRankingEngine()

    @Test("Ranks projects by urgency-adjusted efficiency")
    func projectRanking() throws {
        let result = try engine.calculate(
            .init(
                project1RiskReduction: 0.0005,
                project1Cost: 500_000,
                project1UrgencyRating: 5,
                project2RiskReduction: 0.0008,
                project2Cost: 1_200_000,
                project2UrgencyRating: 4,
                project3RiskReduction: 0.0002,
                project3Cost: 150_000,
                project3UrgencyRating: 3
            )
        )

        #expect(
            abs(
                result.project1PriorityScore
                - 1e-9
            ) < 1e-18
        )

        #expect(
            result.highestPriorityProject
            == "Project 1"
        )

        #expect(
            result.totalPortfolioCost
            == 1_850_000
        )

        #expect(
            abs(
                result.totalPortfolioRiskReduction
                - 0.0015
            ) < 1e-15
        )
    }

    @Test("Highest raw risk reduction need not rank first")
    func urgencyAndCostEffect() throws {
        let result = try engine.calculate(
            .init(
                project1RiskReduction: 1,
                project1Cost: 100,
                project1UrgencyRating: 1,
                project2RiskReduction: 0.5,
                project2Cost: 10,
                project2UrgencyRating: 5,
                project3RiskReduction: 0.1,
                project3Cost: 10,
                project3UrgencyRating: 1
            )
        )

        #expect(
            result.highestPriorityProject
            == "Project 2"
        )
    }

    @Test("Rejects urgency below one")
    func validation() {
        #expect(
            throws:
                SafetyProjectPortfolioRankingError
                    .urgencyOutsideRange
        ) {
            try engine.calculate(
                .init(
                    project1RiskReduction: 1,
                    project1Cost: 100,
                    project1UrgencyRating: 0,
                    project2RiskReduction: 0.5,
                    project2Cost: 10,
                    project2UrgencyRating: 5,
                    project3RiskReduction: 0.1,
                    project3Cost: 10,
                    project3UrgencyRating: 1
                )
            )
        }
    }
}
