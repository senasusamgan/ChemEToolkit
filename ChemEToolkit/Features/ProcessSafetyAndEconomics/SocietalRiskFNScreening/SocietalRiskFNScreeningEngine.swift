import Foundation

struct SocietalRiskFNScreeningEngine:
    Sendable {

    func calculate(
        _ input:
            SocietalRiskFNScreeningInput
    ) throws
        -> SocietalRiskFNScreeningResult {

        let values = [
            input.cumulativeFrequencyPerYear,
            input.fatalityCount,
            input.referenceFrequencyAtOneFatality,
            input.criterionSlopeExponent
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SocietalRiskFNScreeningError
                .nonFiniteInput
        }

        guard
            input.cumulativeFrequencyPerYear > 0,
            input.referenceFrequencyAtOneFatality > 0
        else {
            throw SocietalRiskFNScreeningError
                .nonPositiveFrequency
        }

        let roundedFatalities =
            input.fatalityCount.rounded()

        guard
            abs(
                input.fatalityCount
                - roundedFatalities
            ) < 1e-12,
            roundedFatalities >= 1
        else {
            throw SocietalRiskFNScreeningError
                .invalidFatalityCount
        }

        guard input.criterionSlopeExponent > 0 else {
            throw SocietalRiskFNScreeningError
                .nonPositiveSlopeExponent
        }

        let fatalities =
            Int(roundedFatalities)

        let criterionFrequency =
            input.referenceFrequencyAtOneFatality
            / pow(
                Double(fatalities),
                input.criterionSlopeExponent
            )

        let ratio =
            input.cumulativeFrequencyPerYear
            / criterionFrequency

        let logFrequency =
            log10(
                input.cumulativeFrequencyPerYear
            )

        let logCriterion =
            log10(
                criterionFrequency
            )

        let exceeded =
            ratio > 1

        let band: String
        let description: String

        switch ratio {
        case ..<0.1:
            band =
                "Well below entered criterion"
            description =
                "The entered cumulative frequency is below one tenth of the selected criterion line."

        case ..<1:
            band =
                "Below entered criterion"
            description =
                "The entered cumulative frequency is below the selected criterion line."

        case 1:
            band =
                "On entered criterion"
            description =
                "The entered point lies on the selected criterion line."

        case ..<10:
            band =
                "Above entered criterion"
            description =
                "The entered cumulative frequency exceeds the selected criterion line."

        default:
            band =
                "Far above entered criterion"
            description =
                "The entered cumulative frequency is at least ten times the selected criterion line."
        }

        let outputs = [
            criterionFrequency,
            ratio,
            logFrequency,
            logCriterion
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            criterionFrequency > 0,
            ratio > 0
        else {
            throw SocietalRiskFNScreeningError
                .numericalFailure
        }

        return .init(
            fatalityCount:
                fatalities,
            enteredCumulativeFrequency:
                input.cumulativeFrequencyPerYear,
            criterionFrequency:
                criterionFrequency,
            frequencyToCriterionRatio:
                ratio,
            log10Frequency:
                logFrequency,
            log10CriterionFrequency:
                logCriterion,
            criterionExceeded:
                exceeded,
            assessmentBand:
                band,
            assessmentDescription:
                description,
            modelName:
                "Parameterized societal-risk F–N criterion screening",
            limitationDescription:
                "F–N criteria differ by jurisdiction and organization. This module evaluates only the user-entered criterion line and does not construct a complete cumulative F–N curve from multiple scenarios."
        )
    }
}
