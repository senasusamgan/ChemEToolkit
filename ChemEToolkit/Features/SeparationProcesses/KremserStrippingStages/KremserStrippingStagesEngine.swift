import Foundation

struct KremserStrippingStagesEngine:
    Sendable {

    func calculate(
        _ input:
            KremserStrippingStagesInput
    ) throws
        -> KremserStrippingStagesResult {

        let values = [
            input.strippingFactor,
            input.targetRemovalFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw KremserStrippingStagesError
                .nonFiniteInput
        }

        guard input.strippingFactor > 0 else {
            throw KremserStrippingStagesError
                .nonPositiveStrippingFactor
        }

        guard
            input.targetRemovalFraction > 0,
            input.targetRemovalFraction < 1
        else {
            throw KremserStrippingStagesError
                .invalidRemovalFraction
        }

        let remaining =
            1 - input.targetRemovalFraction

        let estimate: Double

        if
            abs(
                input.strippingFactor - 1
            ) < 1e-10
        {
            estimate =
                1 / remaining - 1
        } else {
            let logarithmArgument =
                1
                + (
                    input.strippingFactor - 1
                )
                / remaining

            guard logarithmArgument > 0 else {
                throw KremserStrippingStagesError
                    .numericalFailure
            }

            estimate =
                Foundation.log(
                    logarithmArgument
                )
                / Foundation.log(
                    input.strippingFactor
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
                input.strippingFactor - 1
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
                    input.strippingFactor - 1
                )
                / (
                    Foundation.pow(
                        input.strippingFactor,
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
            throw KremserStrippingStagesError
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
                "Kremser stripping stage relation with fresh stripping gas",
            limitationDescription:
                "Assumes constant stripping factor, linear equilibrium, dilute solute and solute-free entering gas."
        )
    }
}
