import Foundation

struct RateConstantTemperatureShiftEngine:
    Sendable {

    private let gasConstant = 8.31446261815324

    func calculate(
        _ input: RateConstantTemperatureShiftInput
    ) throws -> RateConstantTemperatureShiftResult {
        let values = [
            input.referenceRateConstant,
            input.referenceTemperature,
            input.targetTemperature,
            input.activationEnergy
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RateConstantTemperatureShiftError.nonFiniteInput
        }
        guard input.referenceRateConstant > 0 else {
            throw RateConstantTemperatureShiftError
                .nonPositiveReferenceRateConstant
        }
        guard
            input.referenceTemperature > 0,
            input.targetTemperature > 0
        else {
            throw RateConstantTemperatureShiftError.nonPositiveTemperature
        }
        guard input.activationEnergy >= 0 else {
            throw RateConstantTemperatureShiftError.negativeActivationEnergy
        }

        let reciprocalChange =
            1 / input.targetTemperature
            - 1 / input.referenceTemperature

        let logRatio =
            -input.activationEnergy
            / gasConstant
            * reciprocalChange

        let ratio = exp(logRatio)
        let targetRateConstant =
            input.referenceRateConstant
            * ratio

        let percentChange =
            100 * (ratio - 1)

        guard
            [
                reciprocalChange,
                logRatio,
                ratio,
                targetRateConstant,
                percentChange
            ]
            .allSatisfy(\.isFinite),
            ratio > 0,
            targetRateConstant > 0
        else {
            throw RateConstantTemperatureShiftError.numericalFailure
        }

        let trend: String

        if input.targetTemperature > input.referenceTemperature {
            trend =
                input.activationEnergy > 0
                ? "The target temperature is higher, so the predicted rate constant increases."
                : "Activation energy is zero, so the rate constant is temperature-independent."
        } else if input.targetTemperature < input.referenceTemperature {
            trend =
                input.activationEnergy > 0
                ? "The target temperature is lower, so the predicted rate constant decreases."
                : "Activation energy is zero, so the rate constant is temperature-independent."
        } else {
            trend =
                "Reference and target temperatures are equal, so the rate constant is unchanged."
        }

        return .init(
            targetRateConstant:
                targetRateConstant,
            rateConstantRatio:
                ratio,
            naturalLogRateRatio:
                logRatio,
            reciprocalTemperatureChange:
                reciprocalChange,
            percentRateConstantChange:
                percentChange,
            trendDescription: trend,
            modelName:
                "Reference-temperature Arrhenius shift",
            limitationDescription:
                "Assumes activation energy remains constant between the reference and target temperatures."
        )
    }
}
