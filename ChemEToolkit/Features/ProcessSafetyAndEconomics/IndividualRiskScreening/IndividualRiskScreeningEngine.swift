struct IndividualRiskScreeningEngine:
    Sendable {

    func calculate(
        _ input:
            IndividualRiskScreeningInput
    ) throws
        -> IndividualRiskScreeningResult {

        let values = [
            input.scenarioFrequencyPerYear,
            input.fatalityProbabilityGivenExposure,
            input.occupancyFraction,
            input.presenceProbability
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw IndividualRiskScreeningError
                .nonFiniteInput
        }

        guard
            input.scenarioFrequencyPerYear >= 0
        else {
            throw IndividualRiskScreeningError
                .negativeScenarioFrequency
        }

        let probabilities = [
            input.fatalityProbabilityGivenExposure,
            input.occupancyFraction,
            input.presenceProbability
        ]

        guard
            probabilities.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw IndividualRiskScreeningError
                .probabilityOutsideRange
        }

        let combinedExposureProbability =
            input.fatalityProbabilityGivenExposure
            * input.occupancyFraction
            * input.presenceProbability

        let annualRisk =
            input.scenarioFrequencyPerYear
            * combinedExposureProbability

        let riskPerMillion =
            annualRisk
            * 1_000_000

        let returnPeriod =
            annualRisk > 0
            ? 1 / annualRisk
            : Double.infinity

        let band: String
        let description: String

        switch annualRisk {
        case 0:
            band =
                "Zero entered screening risk"
            description =
                "The entered scenario or exposure terms produce zero annual individual risk."

        case ..<1e-6:
            band =
                "Below 10⁻⁶ per year"
            description =
                "The screening result is below one in one million per year."

        case ..<1e-5:
            band =
                "10⁻⁶ to below 10⁻⁵ per year"
            description =
                "The screening result lies between one in one million and one in one hundred thousand per year."

        case ..<1e-4:
            band =
                "10⁻⁵ to below 10⁻⁴ per year"
            description =
                "The screening result lies between one in one hundred thousand and one in ten thousand per year."

        default:
            band =
                "At or above 10⁻⁴ per year"
            description =
                "The screening result is at or above one in ten thousand per year."
        }

        let finiteOutputs = [
            combinedExposureProbability,
            annualRisk,
            riskPerMillion
        ]

        guard
            finiteOutputs.allSatisfy(\.isFinite),
            combinedExposureProbability >= 0,
            combinedExposureProbability <= 1,
            annualRisk >= 0,
            riskPerMillion >= 0,
            returnPeriod.isFinite
                || returnPeriod == Double.infinity
        else {
            throw IndividualRiskScreeningError
                .numericalFailure
        }

        return .init(
            annualIndividualRisk:
                annualRisk,
            annualIndividualRiskPerMillion:
                riskPerMillion,
            combinedExposureProbability:
                combinedExposureProbability,
            returnPeriodYears:
                returnPeriod,
            screeningBand:
                band,
            assessmentDescription:
                description,
            modelName:
                "Single-scenario annual individual-risk screening",
            limitationDescription:
                "This is a simplified single-scenario calculation. Full individual-risk contours require multiple scenarios, location-specific exposure, weather distributions, consequence modeling and consistent risk criteria."
        )
    }
}
