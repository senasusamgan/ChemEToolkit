import Foundation

struct AdiabaticBatchReactorEngine:
    Sendable {

    private let gasConstant =
        8.31446261815324

    private let integrationIntervals =
        2000

    func calculate(
        _ input:
            AdiabaticBatchReactorInput
    ) throws
        -> AdiabaticBatchReactorResult {

        let values = [
            input.initialConcentrationA,
            input.preExponentialFactor,
            input.activationEnergy,
            input.initialTemperature,
            input.adiabaticTemperatureRise,
            input.targetConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AdiabaticBatchReactorError
                .nonFiniteInput
        }

        guard
            input.initialConcentrationA > 0,
            input.preExponentialFactor > 0
        else {
            throw AdiabaticBatchReactorError
                .nonPositiveConcentrationOrFactor
        }

        guard input.activationEnergy >= 0 else {
            throw AdiabaticBatchReactorError
                .negativeActivationEnergy
        }

        guard
            input.targetConversion > 0,
            input.targetConversion < 1
        else {
            throw AdiabaticBatchReactorError
                .conversionOutOfRange
        }

        let finalTemperature =
            input.initialTemperature
            + input.adiabaticTemperatureRise
            * input.targetConversion

        guard
            input.initialTemperature > 0,
            finalTemperature > 0
        else {
            throw AdiabaticBatchReactorError
                .nonPositiveTemperature
        }

        func temperature(
            at conversion: Double
        ) -> Double {
            input.initialTemperature
            + input.adiabaticTemperatureRise
            * conversion
        }

        func rateConstant(
            at conversion: Double
        ) -> Double {
            input.preExponentialFactor
            * exp(
                -input.activationEnergy
                / (
                    gasConstant
                    * temperature(
                        at: conversion
                    )
                )
            )
        }

        func integrand(
            at conversion: Double
        ) -> Double {
            1
            / (
                rateConstant(
                    at: conversion
                )
                * (
                    1 - conversion
                )
            )
        }

        let intervalCount =
            integrationIntervals

        let step =
            input.targetConversion
            / Double(intervalCount)

        var sum =
            integrand(at: 0)
            + integrand(
                at: input.targetConversion
            )

        for index in 1..<intervalCount {
            let conversion =
                Double(index)
                * step

            sum += (
                index.isMultiple(of: 2)
                ? 2
                : 4
            )
            * integrand(
                at: conversion
            )
        }

        let time =
            step
            / 3
            * sum

        let initialRateConstant =
            rateConstant(at: 0)

        let finalRateConstant =
            rateConstant(
                at: input.targetConversion
            )

        let isothermalTime =
            -log(
                1 - input.targetConversion
            )
            / initialRateConstant

        let timeRatio =
            isothermalTime
            / time

        let finalConcentration =
            input.initialConcentrationA
            * (
                1 - input.targetConversion
            )

        let initialReactionRate =
            initialRateConstant
            * input.initialConcentrationA

        let finalReactionRate =
            finalRateConstant
            * finalConcentration

        let results = [
            time,
            isothermalTime,
            timeRatio,
            finalTemperature,
            initialRateConstant,
            finalRateConstant,
            finalConcentration,
            initialReactionRate,
            finalReactionRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            time > 0,
            isothermalTime > 0,
            timeRatio > 0,
            finalTemperature > 0,
            initialRateConstant > 0,
            finalRateConstant > 0,
            finalConcentration > 0,
            initialReactionRate > 0,
            finalReactionRate > 0
        else {
            throw AdiabaticBatchReactorError
                .numericalFailure
        }

        return .init(
            timeToTargetConversion:
                time,
            isothermalTimeAtInitialTemperature:
                isothermalTime,
            isothermalToAdiabaticTimeRatio:
                timeRatio,
            initialTemperature:
                input.initialTemperature,
            finalTemperature:
                finalTemperature,
            temperatureChange:
                finalTemperature
                - input.initialTemperature,
            initialRateConstant:
                initialRateConstant,
            finalRateConstant:
                finalRateConstant,
            initialReactionRate:
                initialReactionRate,
            finalReactionRate:
                finalReactionRate,
            finalConcentrationA:
                finalConcentration,
            modelName:
                "Constant-volume adiabatic batch reactor with first-order Arrhenius kinetics and T = T₀ + ΔT_ad X",
            limitationDescription:
                "Assumes constant heat capacity, constant adiabatic temperature-rise parameter, one irreversible first-order reaction and no heat loss. The time integral uses 2000-interval Simpson integration."
        )
    }
}
