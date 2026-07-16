import Foundation

struct SecondOrderProcessResponseEngine:
    Sendable {

    private let criticalTolerance =
        1e-8

    func calculate(
        _ input:
            SecondOrderProcessResponseInput
    ) throws
        -> SecondOrderProcessResponseResult {

        let values = [
            input.initialOutput,
            input.processGain,
            input.inputStepChange,
            input.naturalFrequency,
            input.dampingRatio,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SecondOrderProcessResponseError
                .nonFiniteInput
        }

        guard input.naturalFrequency > 0 else {
            throw SecondOrderProcessResponseError
                .nonPositiveNaturalFrequency
        }

        guard input.dampingRatio > 0 else {
            throw SecondOrderProcessResponseError
                .nonPositiveDampingRatio
        }

        guard input.evaluationTime >= 0 else {
            throw SecondOrderProcessResponseError
                .negativeEvaluationTime
        }

        let zeta =
            input.dampingRatio

        let omega =
            input.naturalFrequency

        let time =
            input.evaluationTime

        let normalizedResponse: Double
        let regime: String
        let dampedFrequency: Double?
        let overshoot: Double
        let peakTime: Double?
        let settlingTime: Double

        if zeta < 1 - criticalTolerance {
            let root =
                sqrt(
                    1 - zeta * zeta
                )

            let omegaD =
                omega * root

            normalizedResponse =
                1
                - exp(
                    -zeta
                    * omega
                    * time
                )
                * (
                    cos(
                        omegaD * time
                    )
                    + zeta
                    / root
                    * sin(
                        omegaD * time
                    )
                )

            regime =
                "Underdamped"

            dampedFrequency =
                omegaD

            overshoot =
                100
                * exp(
                    -zeta
                    * .pi
                    / root
                )

            peakTime =
                .pi / omegaD

            settlingTime =
                4
                / (
                    zeta * omega
                )
        } else if abs(zeta - 1)
            <= criticalTolerance {

            normalizedResponse =
                1
                - exp(
                    -omega * time
                )
                * (
                    1
                    + omega * time
                )

            regime =
                "Critically damped"

            dampedFrequency = nil
            overshoot = 0
            peakTime = nil

            settlingTime =
                4 / omega
        } else {
            let root =
                sqrt(
                    zeta * zeta
                    - 1
                )

            let slowPole =
                -omega
                * (
                    zeta - root
                )

            let fastPole =
                -omega
                * (
                    zeta + root
                )

            normalizedResponse =
                1
                + (
                    fastPole
                    * exp(
                        slowPole * time
                    )
                    - slowPole
                    * exp(
                        fastPole * time
                    )
                )
                / (
                    slowPole - fastPole
                )

            regime =
                "Overdamped"

            dampedFrequency = nil
            overshoot = 0
            peakTime = nil

            settlingTime =
                4
                / abs(slowPole)
        }

        let finalChange =
            input.processGain
            * input.inputStepChange

        let responseChange =
            finalChange
            * normalizedResponse

        let output =
            input.initialOutput
            + responseChange

        let finalOutput =
            input.initialOutput
            + finalChange

        let results = [
            normalizedResponse,
            responseChange,
            output,
            finalOutput,
            overshoot,
            settlingTime
        ]

        guard
            results.allSatisfy(\.isFinite),
            settlingTime > 0,
            overshoot >= 0
        else {
            throw SecondOrderProcessResponseError
                .numericalFailure
        }

        if let dampedFrequency {
            guard
                dampedFrequency.isFinite,
                dampedFrequency > 0
            else {
                throw SecondOrderProcessResponseError
                    .numericalFailure
            }
        }

        if let peakTime {
            guard
                peakTime.isFinite,
                peakTime > 0
            else {
                throw SecondOrderProcessResponseError
                    .numericalFailure
            }
        }

        return .init(
            outputAtEvaluationTime:
                output,
            finalSteadyStateOutput:
                finalOutput,
            normalizedStepResponse:
                normalizedResponse,
            responseChange:
                responseChange,
            dampingRegime:
                regime,
            dampedNaturalFrequency:
                dampedFrequency,
            percentOvershoot:
                overshoot,
            peakTime:
                peakTime,
            approximateTwoPercentSettlingTime:
                settlingTime,
            modelName:
                "Standard second-order step response with gain K, natural frequency ωₙ and damping ratio ζ",
            limitationDescription:
                "Assumes a linear standard second-order transfer function with no zeros or dead time. Settling time is an engineering approximation based on the dominant decay rate."
        )
    }
}
