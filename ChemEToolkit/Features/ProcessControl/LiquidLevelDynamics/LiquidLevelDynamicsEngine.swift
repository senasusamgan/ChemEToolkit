import Foundation

struct LiquidLevelDynamicsEngine:
    Sendable {

    func calculate(
        _ input:
            LiquidLevelDynamicsInput
    ) throws
        -> LiquidLevelDynamicsResult {

        let values = [
            input.tankCrossSectionalArea,
            input.hydraulicResistance,
            input.initialLevel,
            input.inletFlowStepChange,
            input.evaluationTime,
            input.maximumTankLevel
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LiquidLevelDynamicsError
                .nonFiniteInput
        }

        guard
            input.tankCrossSectionalArea > 0,
            input.hydraulicResistance > 0
        else {
            throw LiquidLevelDynamicsError
                .nonPositiveTankProperty
        }

        guard
            input.initialLevel >= 0,
            input.maximumTankLevel
            > input.initialLevel
        else {
            throw LiquidLevelDynamicsError
                .invalidLevelLimit
        }

        guard input.evaluationTime >= 0 else {
            throw LiquidLevelDynamicsError
                .negativeEvaluationTime
        }

        let timeConstant =
            input.tankCrossSectionalArea
            * input.hydraulicResistance

        let finalChange =
            input.hydraulicResistance
            * input.inletFlowStepChange

        let finalLevel =
            input.initialLevel
            + finalChange

        guard finalLevel >= 0 else {
            throw LiquidLevelDynamicsError
                .negativePredictedSteadyLevel
        }

        let completed =
            1
            - exp(
                -input.evaluationTime
                / timeConstant
            )

        let currentLevel =
            input.initialLevel
            + finalChange
            * completed

        let initialRate =
            input.inletFlowStepChange
            / input.tankCrossSectionalArea

        let margin =
            input.maximumTankLevel
            - currentLevel

        let results = [
            timeConstant,
            input.hydraulicResistance,
            currentLevel,
            finalLevel,
            initialRate,
            completed,
            margin
        ]

        guard
            results.allSatisfy(\.isFinite),
            currentLevel >= -1e-10,
            completed >= 0,
            completed <= 1
        else {
            throw LiquidLevelDynamicsError
                .numericalFailure
        }

        return .init(
            timeConstant:
                timeConstant,
            processGain:
                input.hydraulicResistance,
            levelAtEvaluationTime:
                max(
                    0,
                    currentLevel
                ),
            finalSteadyStateLevel:
                finalLevel,
            initialLevelRate:
                initialRate,
            fractionOfFinalChange:
                completed,
            overflowRisk:
                finalLevel
                > input.maximumTankLevel,
            availableLevelMargin:
                margin,
            modelName:
                "Single linear liquid-level tank: A dh/dt = Δq − Δh/R",
            limitationDescription:
                "Treats the flow change as a deviation around an operating point with linear outlet resistance. Emptying, overflow hydraulics and nonlinear valve orifice flow are not modeled."
        )
    }
}
