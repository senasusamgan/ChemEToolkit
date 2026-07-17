import Foundation

struct KremserAbsorptionStagesEngine:
    Sendable {

    func calculate(
        _ input:
            KremserAbsorptionStagesInput
    ) throws
        -> KremserAbsorptionStagesResult {

        let values = [
            input.absorptionFactor,
            input.targetRemovalFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw KremserAbsorptionStagesError
                .nonFiniteInput
        }

        guard input.absorptionFactor > 0 else {
            throw KremserAbsorptionStagesError
                .nonPositiveAbsorptionFactor
        }

        guard
            input.targetRemovalFraction > 0,
            input.targetRemovalFraction < 1
        else {
            throw KremserAbsorptionStagesError
                .invalidRemovalFraction
        }

        let remaining =
            1 - input.targetRemovalFraction

        let estimate: Double

        if
            abs(
                input.absorptionFactor - 1
            ) < 1e-10
        {
            estimate =
                1 / remaining - 1
        } else {
            let logarithmArgument =
                1
                + (
                    input.absorptionFactor - 1
                )
                / remaining

            guard logarithmArgument > 0 else {
                throw KremserAbsorptionStagesError
                    .numericalFailure
            }

            estimate =
                Foundation.log(
                    logarithmArgument
                )
                / Foundation.log(
                    input.absorptionFactor
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
                input.absorptionFactor - 1
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
                    input.absorptionFactor - 1
                )
                / (
                    Foundation.pow(
                        input.absorptionFactor,
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
            throw KremserAbsorptionStagesError
                .numericalFailure
        }

        return .init(
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
                "Kremser absorption stage relation with lean solvent",
            limitationDescription:
                "Assumes constant absorption factor, linear equilibrium, dilute solute and solute-free entering solvent."
        )
    }
}
