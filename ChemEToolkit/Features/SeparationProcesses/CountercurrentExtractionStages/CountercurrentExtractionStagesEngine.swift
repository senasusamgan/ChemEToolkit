import Foundation

struct CountercurrentExtractionStagesEngine:
    Sendable {

    func calculate(
        _ input:
            CountercurrentExtractionStagesInput
    ) throws
        -> CountercurrentExtractionStagesResult {

        let values = [
            input.feedCarrierFlow,
            input.solventCarrierFlow,
            input.distributionCoefficient,
            input.targetRemovalFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CountercurrentExtractionStagesError
                .nonFiniteInput
        }

        guard
            input.feedCarrierFlow > 0,
            input.solventCarrierFlow > 0
        else {
            throw CountercurrentExtractionStagesError
                .nonPositiveFlow
        }

        guard input.distributionCoefficient > 0 else {
            throw CountercurrentExtractionStagesError
                .nonPositiveDistributionCoefficient
        }

        guard
            input.targetRemovalFraction > 0,
            input.targetRemovalFraction < 1
        else {
            throw CountercurrentExtractionStagesError
                .invalidRemovalFraction
        }

        let extractionFactor =
            input.distributionCoefficient
            * input.solventCarrierFlow
            / input.feedCarrierFlow

        let remaining =
            1 - input.targetRemovalFraction

        let estimate: Double

        if
            abs(
                extractionFactor - 1
            ) < 1e-10
        {
            estimate =
                1 / remaining - 1
        } else {
            let logarithmArgument =
                1
                + (
                    extractionFactor - 1
                )
                / remaining

            guard logarithmArgument > 0 else {
                throw CountercurrentExtractionStagesError
                    .numericalFailure
            }

            estimate =
                Foundation.log(
                    logarithmArgument
                )
                / Foundation.log(
                    extractionFactor
                )
                - 1
        }

        let wholeStages =
            max(
                1,
                Int(
                    Foundation.ceil(
                        estimate
                    )
                )
            )

        let achievedRemaining: Double

        if
            abs(
                extractionFactor - 1
            ) < 1e-10
        {
            achievedRemaining =
                1
                / Double(
                    wholeStages + 1
                )
        } else {
            achievedRemaining =
                (
                    extractionFactor - 1
                )
                / (
                    Foundation.pow(
                        extractionFactor,
                        Double(
                            wholeStages + 1
                        )
                    )
                    - 1
                )
        }

        let achievedRemoval =
            1 - achievedRemaining

        let margin =
            achievedRemoval
            - input.targetRemovalFraction

        let outputs = [
            extractionFactor,
            remaining,
            estimate,
            achievedRemaining,
            achievedRemoval,
            margin
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            estimate >= 0,
            achievedRemoval >= 0,
            achievedRemoval <= 1
        else {
            throw CountercurrentExtractionStagesError
                .numericalFailure
        }

        return .init(
            extractionFactor:
                extractionFactor,
            fractionRemaining:
                remaining,
            continuousStageEstimate:
                estimate,
            requiredWholeStages:
                wholeStages,
            achievedRemovalAtWholeStages:
                achievedRemoval,
            stageMargin:
                margin,
            modelName:
                "Countercurrent extraction Kremser relation",
            limitationDescription:
                "Assumes fresh entering solvent, constant extraction factor, linear equilibrium and immiscible carrier phases."
        )
    }
}
