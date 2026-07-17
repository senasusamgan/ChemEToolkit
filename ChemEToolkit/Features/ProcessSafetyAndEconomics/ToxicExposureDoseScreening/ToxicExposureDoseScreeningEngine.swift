import Foundation

struct ToxicExposureDoseScreeningEngine:
    Sendable {

    func calculate(
        _ input:
            ToxicExposureDoseScreeningInput
    ) throws
        -> ToxicExposureDoseScreeningResult {

        let values = [
            input.exposureConcentration,
            input.exposureDuration,
            input.concentrationExponent,
            input.referenceDose
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ToxicExposureDoseScreeningError
                .nonFiniteInput
        }

        guard input.exposureConcentration > 0 else {
            throw ToxicExposureDoseScreeningError
                .nonPositiveConcentration
        }

        guard input.exposureDuration > 0 else {
            throw ToxicExposureDoseScreeningError
                .nonPositiveDuration
        }

        guard input.concentrationExponent > 0 else {
            throw ToxicExposureDoseScreeningError
                .nonPositiveExponent
        }

        guard input.referenceDose > 0 else {
            throw ToxicExposureDoseScreeningError
                .nonPositiveReferenceDose
        }

        let concentrationTerm =
            pow(
                input.exposureConcentration,
                input.concentrationExponent
            )

        let calculatedDose =
            concentrationTerm
            * input.exposureDuration

        let doseRatio =
            calculatedDose
            / input.referenceDose

        let maximumDuration =
            input.referenceDose
            / concentrationTerm

        let maximumConcentration =
            pow(
                input.referenceDose
                / input.exposureDuration,
                1
                / input.concentrationExponent
            )

        let band: String
        let description: String

        switch doseRatio {
        case ..<0.25:
            band = "Well below reference dose"
            description =
                "Calculated dose is below 25% of the entered reference dose."

        case ..<1:
            band = "Below reference dose"
            description =
                "Calculated dose is below, but within one order of magnitude of, the entered reference dose."

        case ..<10:
            band = "Above reference dose"
            description =
                "Calculated dose exceeds the entered reference dose."

        default:
            band = "Far above reference dose"
            description =
                "Calculated dose is at least ten times the entered reference dose."
        }

        let results = [
            concentrationTerm,
            calculatedDose,
            doseRatio,
            maximumDuration,
            maximumConcentration
        ]

        guard
            results.allSatisfy(\.isFinite),
            concentrationTerm > 0,
            calculatedDose > 0,
            doseRatio > 0,
            maximumDuration > 0,
            maximumConcentration > 0
        else {
            throw ToxicExposureDoseScreeningError
                .numericalFailure
        }

        return .init(
            calculatedDose:
                calculatedDose,
            doseRatio:
                doseRatio,
            maximumDurationAtCurrentConcentration:
                maximumDuration,
            maximumConcentrationAtCurrentDuration:
                maximumConcentration,
            targetExceeded:
                doseRatio >= 1,
            exposureBand:
                band,
            screeningDescription:
                description,
            modelName:
                "Generic concentration-exponent toxic dose: D = Cⁿt",
            limitationDescription:
                "The exponent and reference dose must come from an appropriate authoritative source for the chemical and endpoint. This generic screening calculation is not a medical diagnosis or exposure limit."
        )
    }
}
