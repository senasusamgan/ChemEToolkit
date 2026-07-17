import Foundation

struct CrosscurrentExtractionStagesEngine:
    Sendable {

    func calculate(
        _ input:
            CrosscurrentExtractionStagesInput
    ) throws
        -> CrosscurrentExtractionStagesResult {

        let values = [
            input.feedCarrierFlow,
            input.freshSolventPerStage,
            input.distributionCoefficient,
            input.targetRemovalFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CrosscurrentExtractionStagesError
                .nonFiniteInput
        }

        guard
            input.feedCarrierFlow > 0,
            input.freshSolventPerStage > 0
        else {
            throw CrosscurrentExtractionStagesError
                .nonPositiveFlow
        }

        guard input.distributionCoefficient > 0 else {
            throw CrosscurrentExtractionStagesError
                .nonPositiveDistributionCoefficient
        }

        guard
            input.targetRemovalFraction > 0,
            input.targetRemovalFraction < 1
        else {
            throw CrosscurrentExtractionStagesError
                .invalidRemovalFraction
        }

        let extractionFactor =
            input.distributionCoefficient
            * input.freshSolventPerStage
            / input.feedCarrierFlow

        let stageRemaining =
            1 / (1 + extractionFactor)

        let targetRemaining =
            1 - input.targetRemovalFraction

        let estimate =
            Foundation.log(
                targetRemaining
            )
            / Foundation.log(
                stageRemaining
            )

        let wholeStages =
            max(
                1,
                Int(
                    Foundation.ceil(
                        estimate
                    )
                )
            )

        let achievedRemaining =
            Foundation.pow(
                stageRemaining,
                Double(wholeStages)
            )

        let achievedRemoval =
            1 - achievedRemaining

        let totalSolvent =
            Double(wholeStages)
            * input.freshSolventPerStage

        let outputs = [
            extractionFactor,
            stageRemaining,
            targetRemaining,
            estimate,
            achievedRemaining,
            achievedRemoval,
            totalSolvent
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            estimate > 0,
            achievedRemoval >= 0,
            achievedRemoval <= 1
        else {
            throw CrosscurrentExtractionStagesError
                .numericalFailure
        }

        return .init(
            extractionFactorPerStage:
                extractionFactor,
            singleStageFractionRemaining:
                stageRemaining,
            continuousStageEstimate:
                estimate,
            requiredWholeStages:
                wholeStages,
            achievedRemovalAtWholeStages:
                achievedRemoval,
            totalFreshSolvent:
                totalSolvent,
            modelName:
                "Equal-solvent crosscurrent extraction stages",
            limitationDescription:
                "Each stage receives the same quantity of fresh solute-free solvent with constant K_D and immiscible carrier phases."
        )
    }
}
