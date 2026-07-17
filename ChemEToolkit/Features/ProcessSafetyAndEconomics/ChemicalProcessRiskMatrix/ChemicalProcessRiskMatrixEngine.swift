struct ChemicalProcessRiskMatrixEngine:
    Sendable {

    func calculate(
        _ input:
            ChemicalProcessRiskMatrixInput
    ) throws
        -> ChemicalProcessRiskMatrixResult {

        let values = [
            input.likelihoodRating,
            input.severityRating,
            input.existingSafeguardCredit
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ChemicalProcessRiskMatrixError
                .nonFiniteInput
        }

        func wholeNumber(
            _ value: Double,
            range: ClosedRange<Double>
        ) -> Int? {
            let rounded =
                value.rounded()

            guard
                abs(value - rounded)
                    < 1e-12,
                range.contains(rounded)
            else {
                return nil
            }

            return Int(rounded)
        }

        guard
            let likelihood =
                wholeNumber(
                    input.likelihoodRating,
                    range: 1...5
                )
        else {
            throw ChemicalProcessRiskMatrixError
                .invalidLikelihoodRating
        }

        guard
            let severity =
                wholeNumber(
                    input.severityRating,
                    range: 1...5
                )
        else {
            throw ChemicalProcessRiskMatrixError
                .invalidSeverityRating
        }

        guard
            let safeguardCredit =
                wholeNumber(
                    input.existingSafeguardCredit,
                    range: 0...4
                )
        else {
            throw ChemicalProcessRiskMatrixError
                .invalidSafeguardCredit
        }

        let inherentScore =
            likelihood
            * severity

        let residualScore =
            max(
                1,
                inherentScore
                - safeguardCredit
            )

        func band(
            for score: Int
        ) -> String {
            switch score {
            case 1...4:
                return "Low"
            case 5...9:
                return "Moderate"
            case 10...16:
                return "High"
            default:
                return "Critical"
            }
        }

        let inherentBand =
            band(for: inherentScore)

        let residualBand =
            band(for: residualScore)

        let actionPriority: String

        switch residualScore {
        case 1...4:
            actionPriority =
                "Maintain controls and monitor through routine review."
        case 5...9:
            actionPriority =
                "Plan additional risk reduction and assign an owner."
        case 10...16:
            actionPriority =
                "Prompt engineering or procedural action is required."
        default:
            actionPriority =
                "Immediate escalation; do not proceed without substantial risk reduction."
        }

        let reductionFraction =
            Double(
                inherentScore
                - residualScore
            )
            / Double(inherentScore)

        guard
            reductionFraction.isFinite,
            reductionFraction >= 0,
            reductionFraction < 1
        else {
            throw ChemicalProcessRiskMatrixError
                .numericalFailure
        }

        return .init(
            likelihoodRating:
                likelihood,
            severityRating:
                severity,
            inherentRiskScore:
                inherentScore,
            safeguardCredit:
                safeguardCredit,
            residualRiskScore:
                residualScore,
            inherentRiskBand:
                inherentBand,
            residualRiskBand:
                residualBand,
            actionPriority:
                actionPriority,
            riskReductionFraction:
                reductionFraction,
            modelName:
                "Five-by-five likelihood-severity screening matrix",
            limitationDescription:
                "Risk matrices are qualitative screening tools and are sensitive to rating definitions. Safeguard credit is a simplified score reduction, not an independent protection-layer or SIL calculation."
        )
    }
}
