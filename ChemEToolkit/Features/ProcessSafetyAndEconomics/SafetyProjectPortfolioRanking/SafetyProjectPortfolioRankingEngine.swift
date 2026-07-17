struct SafetyProjectPortfolioRankingEngine:
    Sendable {

    func calculate(
        _ input:
            SafetyProjectPortfolioRankingInput
    ) throws
        -> SafetyProjectPortfolioRankingResult {

        let values = [
            input.project1RiskReduction,
            input.project1Cost,
            input.project1UrgencyRating,
            input.project2RiskReduction,
            input.project2Cost,
            input.project2UrgencyRating,
            input.project3RiskReduction,
            input.project3Cost,
            input.project3UrgencyRating
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SafetyProjectPortfolioRankingError
                .nonFiniteInput
        }

        let riskReductions = [
            input.project1RiskReduction,
            input.project2RiskReduction,
            input.project3RiskReduction
        ]

        guard
            riskReductions.allSatisfy({
                $0 >= 0
            })
        else {
            throw SafetyProjectPortfolioRankingError
                .negativeRiskReduction
        }

        let costs = [
            input.project1Cost,
            input.project2Cost,
            input.project3Cost
        ]

        guard costs.allSatisfy({ $0 > 0 }) else {
            throw SafetyProjectPortfolioRankingError
                .nonPositiveProjectCost
        }

        let urgencies = [
            input.project1UrgencyRating,
            input.project2UrgencyRating,
            input.project3UrgencyRating
        ]

        guard
            urgencies.allSatisfy({
                $0 >= 1 && $0 <= 5
            })
        else {
            throw SafetyProjectPortfolioRankingError
                .urgencyOutsideRange
        }

        let projects = [
            (
                name: "Project 1",
                riskReduction:
                    input.project1RiskReduction,
                cost:
                    input.project1Cost,
                urgency:
                    input.project1UrgencyRating
            ),
            (
                name: "Project 2",
                riskReduction:
                    input.project2RiskReduction,
                cost:
                    input.project2Cost,
                urgency:
                    input.project2UrgencyRating
            ),
            (
                name: "Project 3",
                riskReduction:
                    input.project3RiskReduction,
                cost:
                    input.project3Cost,
                urgency:
                    input.project3UrgencyRating
            )
        ]

        let scores = projects.map {
            $0.riskReduction
            / $0.cost
            * (
                $0.urgency
                / 5
            )
        }

        let ranked = zip(
            projects,
            scores
        )
        .max {
            $0.1 < $1.1
        }

        let totalCost =
            costs.reduce(0, +)

        let totalRiskReduction =
            riskReductions.reduce(0, +)

        let portfolioEfficiency =
            totalRiskReduction
            / totalCost

        let highestProject =
            ranked?.0.name
            ?? "None"

        let highestScore =
            ranked?.1
            ?? 0

        let description =
            "\(highestProject) has the highest urgency-adjusted risk-reduction-per-cost score."

        let outputs = [
            scores[0],
            scores[1],
            scores[2],
            highestScore,
            totalCost,
            totalRiskReduction,
            portfolioEfficiency
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            scores.allSatisfy({
                $0 >= 0
            }),
            totalCost > 0,
            totalRiskReduction >= 0,
            portfolioEfficiency >= 0
        else {
            throw SafetyProjectPortfolioRankingError
                .numericalFailure
        }

        return .init(
            project1PriorityScore:
                scores[0],
            project2PriorityScore:
                scores[1],
            project3PriorityScore:
                scores[2],
            highestPriorityProject:
                highestProject,
            highestPriorityScore:
                highestScore,
            totalPortfolioCost:
                totalCost,
            totalPortfolioRiskReduction:
                totalRiskReduction,
            portfolioRiskReductionPerCost:
                portfolioEfficiency,
            rankingDescription:
                description,
            modelName:
                "Urgency-adjusted risk-reduction-per-cost portfolio ranking",
            limitationDescription:
                "Priority scores are only as reliable as the entered risk-reduction, cost and urgency estimates. Mandatory actions, dependencies, implementation time, uncertainty and ethical constraints must override simple ranking where applicable."
        )
    }
}
