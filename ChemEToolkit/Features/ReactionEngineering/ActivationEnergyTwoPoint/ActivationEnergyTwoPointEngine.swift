import Foundation

struct ActivationEnergyTwoPointEngine:
    Sendable {

    private let gasConstant = 8.31446261815324
    private let temperatureTolerance = 1.0e-12

    func calculate(
        _ input: ActivationEnergyTwoPointInput
    ) throws -> ActivationEnergyTwoPointResult {
        let values = [
            input.temperatureOne,
            input.rateConstantOne,
            input.temperatureTwo,
            input.rateConstantTwo
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ActivationEnergyTwoPointError.nonFiniteInput
        }
        guard
            input.temperatureOne > 0,
            input.rateConstantOne > 0,
            input.temperatureTwo > 0,
            input.rateConstantTwo > 0
        else {
            throw ActivationEnergyTwoPointError
                .nonPositiveTemperatureOrRateConstant
        }

        let reciprocalDifference =
            1 / input.temperatureOne
            - 1 / input.temperatureTwo

        guard abs(reciprocalDifference) > temperatureTolerance else {
            throw ActivationEnergyTwoPointError.equalTemperatures
        }

        let logRateRatio =
            log(
                input.rateConstantTwo
                / input.rateConstantOne
            )

        let activationEnergy =
            gasConstant
            * logRateRatio
            / reciprocalDifference

        guard activationEnergy > 0 else {
            throw ActivationEnergyTwoPointError.nonPositiveActivationEnergy
        }

        let factorOne =
            input.rateConstantOne
            * exp(
                activationEnergy
                / (
                    gasConstant
                    * input.temperatureOne
                )
            )

        let factorTwo =
            input.rateConstantTwo
            * exp(
                activationEnergy
                / (
                    gasConstant
                    * input.temperatureTwo
                )
            )

        let averageFactor =
            0.5
            * (
                factorOne
                + factorTwo
            )

        let mismatch =
            abs(factorOne - factorTwo)
            / averageFactor

        guard
            [
                activationEnergy,
                factorOne,
                factorTwo,
                averageFactor,
                logRateRatio,
                reciprocalDifference,
                mismatch
            ]
            .allSatisfy(\.isFinite),
            factorOne > 0,
            factorTwo > 0,
            averageFactor > 0,
            mismatch >= 0
        else {
            throw ActivationEnergyTwoPointError.numericalFailure
        }

        let trend =
            input.temperatureTwo > input.temperatureOne
            ? "The higher-temperature point has the larger rate constant, consistent with positive activation energy."
            : "The lower-temperature point is listed second; the paired rate constants remain consistent with positive activation energy."

        return .init(
            activationEnergy: activationEnergy,
            activationEnergyKilojoulesPerMole:
                activationEnergy / 1000,
            preExponentialFactorFromPointOne:
                factorOne,
            preExponentialFactorFromPointTwo:
                factorTwo,
            averagePreExponentialFactor:
                averageFactor,
            naturalLogRateRatio:
                logRateRatio,
            reciprocalTemperatureDifference:
                reciprocalDifference,
            relativePreExponentialMismatch:
                mismatch,
            trendDescription: trend,
            modelName:
                "Two-point Arrhenius activation-energy relation"
        )
    }
}
