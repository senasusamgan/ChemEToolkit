import Foundation

struct ArrheniusRateConstantEngine:
    Sendable {

    private let gasConstant = 8.31446261815324

    func calculate(
        _ input: ArrheniusRateConstantInput
    ) throws -> ArrheniusRateConstantResult {
        let values = [
            input.preExponentialFactor,
            input.activationEnergy,
            input.temperature
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ArrheniusRateConstantError.nonFiniteInput
        }
        guard input.preExponentialFactor > 0 else {
            throw ArrheniusRateConstantError.nonPositivePreExponentialFactor
        }
        guard input.activationEnergy >= 0 else {
            throw ArrheniusRateConstantError.negativeActivationEnergy
        }
        guard input.temperature > 0 else {
            throw ArrheniusRateConstantError.nonPositiveTemperature
        }

        let activationOverRT =
            input.activationEnergy
            / (gasConstant * input.temperature)

        let exponentialFactor =
            exp(-activationOverRT)

        let rateConstant =
            input.preExponentialFactor
            * exponentialFactor

        let lnRateConstant =
            log(input.preExponentialFactor)
            - activationOverRT

        let sensitivity =
            input.activationEnergy
            / (
                gasConstant
                * input.temperature
                * input.temperature
            )

        let doublingTemperature: Double

        if input.activationEnergy == 0 {
            doublingTemperature = .infinity
        } else {
            let reciprocalTemperature =
                1 / input.temperature
                - gasConstant
                * log(2)
                / input.activationEnergy

            doublingTemperature =
                reciprocalTemperature > 0
                ? 1 / reciprocalTemperature
                : .infinity
        }

        guard
            rateConstant.isFinite,
            exponentialFactor.isFinite,
            activationOverRT.isFinite,
            lnRateConstant.isFinite,
            sensitivity.isFinite,
            rateConstant > 0,
            exponentialFactor > 0,
            exponentialFactor <= 1,
            activationOverRT >= 0,
            sensitivity >= 0
        else {
            throw ArrheniusRateConstantError.numericalFailure
        }

        return .init(
            rateConstant: rateConstant,
            exponentialFactor: exponentialFactor,
            activationEnergyOverRT: activationOverRT,
            naturalLogRateConstant: lnRateConstant,
            temperatureSensitivity: sensitivity,
            temperatureForDoubleRateApproximation: doublingTemperature,
            modelName:
                "Arrhenius rate-constant equation",
            limitationDescription:
                "Assumes a temperature-independent activation energy and pre-exponential factor over the temperature range of interest."
        )
    }
}
