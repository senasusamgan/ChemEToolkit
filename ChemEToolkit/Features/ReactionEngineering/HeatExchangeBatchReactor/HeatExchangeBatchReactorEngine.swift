import Foundation

struct HeatExchangeBatchReactorEngine: Sendable {
    private let gasConstant = 8.31446261815324
    private let integrationSteps = 20_000

    func calculate(
        _ input: HeatExchangeBatchReactorInput
    ) throws -> HeatExchangeBatchReactorResult {
        let values = [
            input.initialConcentrationA,
            input.preExponentialFactor,
            input.activationEnergy,
            input.initialTemperature,
            input.adiabaticTemperatureRise,
            input.coolantTemperature,
            input.heatRemovalCoefficient,
            input.targetConversion,
            input.maximumIntegrationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw HeatExchangeBatchReactorError.nonFiniteInput
        }
        guard input.initialConcentrationA > 0, input.preExponentialFactor > 0 else {
            throw HeatExchangeBatchReactorError.nonPositiveConcentrationOrFactor
        }
        guard input.activationEnergy >= 0 else {
            throw HeatExchangeBatchReactorError.negativeActivationEnergy
        }
        guard input.initialTemperature > 0, input.coolantTemperature > 0 else {
            throw HeatExchangeBatchReactorError.nonPositiveTemperature
        }
        guard input.heatRemovalCoefficient >= 0 else {
            throw HeatExchangeBatchReactorError.negativeHeatRemovalCoefficient
        }
        guard input.targetConversion > 0, input.targetConversion < 1 else {
            throw HeatExchangeBatchReactorError.conversionOutOfRange
        }
        guard input.maximumIntegrationTime > 0 else {
            throw HeatExchangeBatchReactorError.nonPositiveMaximumTime
        }

        func rateConstant(_ temperature: Double) -> Double {
            input.preExponentialFactor
            * exp(-input.activationEnergy / (gasConstant * temperature))
        }

        func derivatives(
            conversion: Double,
            temperature: Double
        ) -> (x: Double, temperature: Double) {
            let rate = rateConstant(temperature) * (1 - conversion)
            return (
                rate,
                input.adiabaticTemperatureRise * rate
                - input.heatRemovalCoefficient
                * (temperature - input.coolantTemperature)
            )
        }

        let dt = input.maximumIntegrationTime / Double(integrationSteps)
        var time = 0.0
        var conversion = 0.0
        var temperature = input.initialTemperature
        var maximumTemperature = temperature

        for _ in 0..<integrationSteps {
            let previousTime = time
            let previousConversion = conversion
            let previousTemperature = temperature

            let k1 = derivatives(conversion: conversion, temperature: temperature)
            let k2 = derivatives(
                conversion: conversion + 0.5 * dt * k1.x,
                temperature: temperature + 0.5 * dt * k1.temperature
            )
            let k3 = derivatives(
                conversion: conversion + 0.5 * dt * k2.x,
                temperature: temperature + 0.5 * dt * k2.temperature
            )
            let k4 = derivatives(
                conversion: conversion + dt * k3.x,
                temperature: temperature + dt * k3.temperature
            )

            conversion += dt / 6 * (k1.x + 2 * k2.x + 2 * k3.x + k4.x)
            temperature += dt / 6 * (
                k1.temperature
                + 2 * k2.temperature
                + 2 * k3.temperature
                + k4.temperature
            )
            time += dt

            guard conversion.isFinite, temperature.isFinite, temperature > 0 else {
                throw HeatExchangeBatchReactorError.numericalFailure
            }

            maximumTemperature = max(maximumTemperature, temperature)

            if conversion >= input.targetConversion {
                let fraction = (input.targetConversion - previousConversion)
                    / (conversion - previousConversion)
                let targetTime = previousTime + fraction * dt
                let targetTemperature = previousTemperature
                    + fraction * (temperature - previousTemperature)
                let finalConcentration = input.initialConcentrationA
                    * (1 - input.targetConversion)
                let initialK = rateConstant(input.initialTemperature)
                let finalK = rateConstant(targetTemperature)
                let released = input.adiabaticTemperatureRise * input.targetConversion
                let retained = targetTemperature - input.initialTemperature
                let removed = released - retained
                let retainedFraction = abs(released) > 1e-14
                    ? retained / released
                    : 0

                let results = [
                    targetTime,
                    targetTemperature,
                    maximumTemperature,
                    finalConcentration,
                    initialK,
                    finalK,
                    released,
                    removed,
                    retainedFraction
                ]

                guard results.allSatisfy(\.isFinite), targetTime > 0 else {
                    throw HeatExchangeBatchReactorError.numericalFailure
                }

                return .init(
                    timeToTargetConversion: targetTime,
                    finalTemperature: targetTemperature,
                    maximumTemperature: maximumTemperature,
                    finalConcentrationA: finalConcentration,
                    initialRateConstant: initialK,
                    finalRateConstant: finalK,
                    heatReleasedTemperatureEquivalent: released,
                    heatRemovedTemperatureEquivalent: removed,
                    retainedHeatFraction: retainedFraction,
                    modelName:
                        "Lumped heat-exchange batch reactor with first-order Arrhenius kinetics",
                    limitationDescription:
                        "Solves coupled conversion and temperature balances with RK4. Assumes constant heat capacity, constant coolant temperature and a lumped linear heat-removal coefficient."
                )
            }
        }

        throw HeatExchangeBatchReactorError.targetNotReached
    }
}
