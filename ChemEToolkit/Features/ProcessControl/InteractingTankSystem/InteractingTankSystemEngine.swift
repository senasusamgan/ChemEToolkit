import Foundation

struct InteractingTankSystemEngine:
    Sendable {

    private let criticalTolerance =
        1e-8

    func calculate(
        _ input:
            InteractingTankSystemInput
    ) throws
        -> InteractingTankSystemResult {

        let values = [
            input.firstTankArea,
            input.secondTankArea,
            input.interTankResistance,
            input.outletResistance,
            input.inletFlowStepChange,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw InteractingTankSystemError
                .nonFiniteInput
        }

        guard
            input.firstTankArea > 0,
            input.secondTankArea > 0,
            input.interTankResistance > 0,
            input.outletResistance > 0
        else {
            throw InteractingTankSystemError
                .nonPositiveTankProperty
        }

        guard input.evaluationTime >= 0 else {
            throw InteractingTankSystemError
                .negativeEvaluationTime
        }

        let quadraticCoefficient =
            input.firstTankArea
            * input.secondTankArea
            * input.interTankResistance
            * input.outletResistance

        let linearCoefficient =
            input.firstTankArea
            * (
                input.interTankResistance
                + input.outletResistance
            )
            + input.secondTankArea
            * input.outletResistance

        let naturalFrequency =
            1
            / quadraticCoefficient.squareRoot()

        let dampingRatio =
            linearCoefficient
            / (
                2
                * quadraticCoefficient.squareRoot()
            )

        let normalizedResponse: Double
        let regime: String
        let slowPole: Double
        let fastPole: Double

        if dampingRatio < 1 - criticalTolerance {
            let root =
                (
                    1
                    - dampingRatio
                    * dampingRatio
                ).squareRoot()

            let dampedFrequency =
                naturalFrequency * root

            normalizedResponse =
                1
                - exp(
                    -dampingRatio
                    * naturalFrequency
                    * input.evaluationTime
                )
                * (
                    cos(
                        dampedFrequency
                        * input.evaluationTime
                    )
                    + dampingRatio / root
                    * sin(
                        dampedFrequency
                        * input.evaluationTime
                    )
                )

            regime = "Underdamped"

            slowPole =
                -dampingRatio
                * naturalFrequency

            fastPole = slowPole
        } else if abs(dampingRatio - 1)
            <= criticalTolerance {

            let normalizedTime =
                naturalFrequency
                * input.evaluationTime

            normalizedResponse =
                1
                - exp(-normalizedTime)
                * (
                    1 + normalizedTime
                )

            regime = "Critically damped"

            slowPole =
                -naturalFrequency

            fastPole =
                -naturalFrequency
        } else {
            let root =
                (
                    dampingRatio
                    * dampingRatio
                    - 1
                ).squareRoot()

            slowPole =
                -naturalFrequency
                * (
                    dampingRatio - root
                )

            fastPole =
                -naturalFrequency
                * (
                    dampingRatio + root
                )

            normalizedResponse =
                1
                + (
                    fastPole
                    * exp(
                        slowPole
                        * input.evaluationTime
                    )
                    - slowPole
                    * exp(
                        fastPole
                        * input.evaluationTime
                    )
                )
                / (
                    slowPole - fastPole
                )

            regime = "Overdamped"
        }

        let finalOutletChange =
            input.outletResistance
            * input.inletFlowStepChange

        let outletChange =
            finalOutletChange
            * normalizedResponse

        let finalFirstChange =
            (
                input.interTankResistance
                + input.outletResistance
            )
            * input.inletFlowStepChange

        let results = [
            quadraticCoefficient,
            linearCoefficient,
            naturalFrequency,
            dampingRatio,
            normalizedResponse,
            outletChange,
            finalOutletChange,
            finalFirstChange,
            slowPole,
            fastPole
        ]

        guard
            results.allSatisfy(\.isFinite),
            quadraticCoefficient > 0,
            linearCoefficient > 0,
            naturalFrequency > 0,
            dampingRatio > 0,
            normalizedResponse >= -1e-8,
            normalizedResponse <= 1 + 1e-8,
            slowPole < 0,
            fastPole < 0
        else {
            throw InteractingTankSystemError
                .numericalFailure
        }

        return .init(
            denominatorQuadraticCoefficient:
                quadraticCoefficient,
            denominatorLinearCoefficient:
                linearCoefficient,
            naturalFrequency:
                naturalFrequency,
            dampingRatio:
                dampingRatio,
            dampingRegime:
                regime,
            normalizedOutletResponse:
                min(
                    1,
                    max(
                        0,
                        normalizedResponse
                    )
                ),
            outletLevelChange:
                outletChange,
            finalOutletLevelChange:
                finalOutletChange,
            finalFirstTankLevelChange:
                finalFirstChange,
            slowPole:
                slowPole,
            fastPole:
                fastPole,
            modelName:
                "Two interacting liquid tanks with flow proportional to the level difference",
            limitationDescription:
                "Assumes linear hydraulic resistances, constant tank areas and a step inlet-flow disturbance. The inter-tank flow depends on h₁−h₂, so the two levels are dynamically coupled."
        )
    }
}
