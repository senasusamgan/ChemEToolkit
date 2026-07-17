struct InherentlySaferDesignChecklistEngine:
    Sendable {

    func calculate(
        _ input:
            InherentlySaferDesignChecklistInput
    ) throws
        -> InherentlySaferDesignChecklistResult {

        let ratings = [
            input.minimizeRating,
            input.substituteRating,
            input.moderateRating,
            input.simplifyRating,
            input.implementationConfidence
        ]

        guard ratings.allSatisfy(\.isFinite) else {
            throw InherentlySaferDesignChecklistError
                .nonFiniteInput
        }

        guard
            ratings.allSatisfy({
                $0 >= 0 && $0 <= 5
            })
        else {
            throw InherentlySaferDesignChecklistError
                .ratingOutsideRange
        }

        let principles = [
            (
                name: "Minimize",
                score: input.minimizeRating
            ),
            (
                name: "Substitute",
                score: input.substituteRating
            ),
            (
                name: "Moderate",
                score: input.moderateRating
            ),
            (
                name: "Simplify",
                score: input.simplifyRating
            )
        ]

        let principleScore =
            principles.reduce(0) {
                $0 + $1.score
            }

        let maximumScore =
            20.0

        let coverage =
            principleScore
            / maximumScore

        let confidenceFraction =
            input.implementationConfidence
            / 5

        let adjustedScore =
            principleScore
            * confidenceFraction

        let weakestPrinciple =
            principles.min {
                $0.score < $1.score
            }?.name
            ?? "None"

        let maturityBand: String

        switch coverage {
        case ..<0.25:
            maturityBand =
                "Initial"
        case ..<0.5:
            maturityBand =
                "Developing"
        case ..<0.75:
            maturityBand =
                "Established"
        default:
            maturityBand =
                "Strong"
        }

        let recommendation =
            "Prioritize \(weakestPrinciple.lowercased()) opportunities and verify that claimed changes reduce the hazard rather than only adding protective layers."

        let results = [
            principleScore,
            maximumScore,
            coverage,
            adjustedScore
        ]

        guard
            results.allSatisfy(\.isFinite),
            principleScore >= 0,
            principleScore <= maximumScore,
            coverage >= 0,
            coverage <= 1,
            adjustedScore >= 0,
            adjustedScore <= maximumScore
        else {
            throw InherentlySaferDesignChecklistError
                .numericalFailure
        }

        return .init(
            principleScore:
                principleScore,
            maximumPrincipleScore:
                maximumScore,
            coverageFraction:
                coverage,
            confidenceAdjustedScore:
                adjustedScore,
            weakestPrinciple:
                weakestPrinciple,
            maturityBand:
                maturityBand,
            priorityRecommendation:
                recommendation,
            modelName:
                "Minimize–Substitute–Moderate–Simplify screening checklist",
            limitationDescription:
                "The ratings are qualitative prompts, not a risk metric. A high score does not demonstrate acceptable risk, regulatory compliance or successful implementation."
        )
    }
}
