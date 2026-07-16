import Foundation

struct NonInteractingTankSystemEngine:
    Sendable {

    private let equalityTolerance =
        1e-10

    func calculate(
        _ input:
            NonInteractingTankSystemInput
    ) throws
        -> NonInteractingTankSystemResult {

        let values = [
            input.firstTankArea,
            input.firstTankResistance,
            input.secondTankArea,
            input.secondTankResistance,
            input.inletFlowStepChange,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw NonInteractingTankSystemError
                .nonFiniteInput
        }

        guard
            input.firstTankArea > 0,
            input.firstTankResistance > 0,
            input.secondTankArea > 0,
            input.secondTankResistance > 0
        else {
            throw NonInteractingTankSystemError
                .nonPositiveTankProperty
        }

        guard input.evaluationTime >= 0 else {
            throw NonInteractingTankSystemError
                .negativeEvaluationTime
        }

        let firstTimeConstant =
            input.firstTankArea
            * input.firstTankResistance

        let secondTimeConstant =
            input.secondTankArea
            * input.secondTankResistance

        let firstResponse =
            1
            - exp(
                -input.evaluationTime
                / firstTimeConstant
            )

        let scale =
            max(
                1,
                firstTimeConstant,
                secondTimeConstant
            )

        let equalTimeConstants =
            abs(
                firstTimeConstant
                - secondTimeConstant
            )
            <= equalityTolerance * scale

        let outletResponse: Double

        if equalTimeConstants {
            let normalizedTime =
                input.evaluationTime
                / firstTimeConstant

            outletResponse =
                1
                - exp(-normalizedTime)
                * (
                    1 + normalizedTime
                )
        } else {
            outletResponse =
                1
                - (
                    firstTimeConstant
                    * exp(
                        -input.evaluationTime
                        / firstTimeConstant
                    )
                    - secondTimeConstant
                    * exp(
                        -input.evaluationTime
                        / secondTimeConstant
                    )
                )
                / (
                    firstTimeConstant
                    - secondTimeConstant
                )
        }

        let finalFirstChange =
            input.firstTankResistance
            * input.inletFlowStepChange

        let finalSecondChange =
            input.secondTankResistance
            * input.inletFlowStepChange

        let firstLevelChange =
            finalFirstChange
            * firstResponse

        let secondLevelChange =
            finalSecondChange
            * outletResponse

        let meanResidenceTime =
            firstTimeConstant
            + secondTimeConstant

        let results = [
            firstTimeConstant,
            secondTimeConstant,
            firstLevelChange,
            secondLevelChange,
            finalFirstChange,
            finalSecondChange,
            outletResponse,
            meanResidenceTime
        ]

        guard
            results.allSatisfy(\.isFinite),
            firstTimeConstant > 0,
            secondTimeConstant > 0,
            outletResponse >= -1e-10,
            outletResponse <= 1 + 1e-10
        else {
            throw NonInteractingTankSystemError
                .numericalFailure
        }

        return .init(
            firstTankTimeConstant:
                firstTimeConstant,
            secondTankTimeConstant:
                secondTimeConstant,
            firstTankLevelChange:
                firstLevelChange,
            secondTankLevelChange:
                secondLevelChange,
            finalFirstTankLevelChange:
                finalFirstChange,
            finalSecondTankLevelChange:
                finalSecondChange,
            normalizedOutletResponse:
                min(
                    1,
                    max(
                        0,
                        outletResponse
                    )
                ),
            combinedMeanResidenceTime:
                meanResidenceTime,
            equalTimeConstants:
                equalTimeConstants,
            modelName:
                "Two non-interacting first-order liquid tanks in series",
            limitationDescription:
                "Assumes linear hydraulic resistances, constant cross-sectional areas and a step change in inlet flow. The first tank outlet is unaffected by the second tank level."
        )
    }
}
