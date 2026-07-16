import Foundation

struct NonIsothermalCSTRSteadyStatesEngine: Sendable {
    private let gasConstant = 8.31446261815324
    private let scanIntervals = 12_000
    private let bisectionIterations = 100

    func calculate(
        _ input: NonIsothermalCSTRSteadyStatesInput
    ) throws -> NonIsothermalCSTRSteadyStatesResult {
        let values = [
            input.inletConcentrationA,
            input.spaceTime,
            input.preExponentialFactor,
            input.activationEnergy,
            input.inletTemperature,
            input.adiabaticTemperatureRise,
            input.coolantTemperature,
            input.heatRemovalNumber
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw NonIsothermalCSTRSteadyStatesError.nonFiniteInput
        }
        guard input.inletConcentrationA > 0, input.spaceTime > 0 else {
            throw NonIsothermalCSTRSteadyStatesError
                .nonPositiveConcentrationOrSpaceTime
        }
        guard input.preExponentialFactor > 0 else {
            throw NonIsothermalCSTRSteadyStatesError
                .nonPositivePreExponentialFactor
        }
        guard input.activationEnergy >= 0 else {
            throw NonIsothermalCSTRSteadyStatesError.negativeActivationEnergy
        }
        guard input.inletTemperature > 0, input.coolantTemperature > 0 else {
            throw NonIsothermalCSTRSteadyStatesError.nonPositiveTemperature
        }
        guard input.adiabaticTemperatureRise > 0 else {
            throw NonIsothermalCSTRSteadyStatesError.nonPositiveAdiabaticRise
        }
        guard input.heatRemovalNumber >= 0 else {
            throw NonIsothermalCSTRSteadyStatesError.negativeHeatRemovalNumber
        }

        let energyDenominator = 1 + input.heatRemovalNumber
        let minimumTemperature = (
            input.inletTemperature
            + input.heatRemovalNumber * input.coolantTemperature
        ) / energyDenominator
        let maximumTemperature = (
            input.inletTemperature
            + input.adiabaticTemperatureRise
            + input.heatRemovalNumber * input.coolantTemperature
        ) / energyDenominator

        guard minimumTemperature > 0, maximumTemperature > minimumTemperature else {
            throw NonIsothermalCSTRSteadyStatesError.nonPositiveTemperature
        }

        func rateConstant(_ temperature: Double) -> Double {
            input.preExponentialFactor
            * exp(-input.activationEnergy / (gasConstant * temperature))
        }

        func materialConversion(_ temperature: Double) -> Double {
            let damkohler = rateConstant(temperature) * input.spaceTime
            return damkohler / (1 + damkohler)
        }

        func energyConversion(_ temperature: Double) -> Double {
            (
                energyDenominator * temperature
                - input.inletTemperature
                - input.heatRemovalNumber * input.coolantTemperature
            ) / input.adiabaticTemperatureRise
        }

        func residual(_ temperature: Double) -> Double {
            materialConversion(temperature)
            - energyConversion(temperature)
        }

        let step = (maximumTemperature - minimumTemperature)
            / Double(scanIntervals)
        var roots: [Double] = []

        func appendRoot(_ temperature: Double) {
            let tolerance = 1e-7 * max(1, temperature)
            if roots.allSatisfy({ abs($0 - temperature) > tolerance }) {
                roots.append(temperature)
            }
        }

        var previousTemperature = minimumTemperature
        var previousResidual = residual(previousTemperature)

        if abs(previousResidual) < 1e-10 {
            appendRoot(previousTemperature)
        }

        for index in 1...scanIntervals {
            let currentTemperature =
                minimumTemperature + Double(index) * step
            let currentResidual = residual(currentTemperature)

            guard previousResidual.isFinite, currentResidual.isFinite else {
                throw NonIsothermalCSTRSteadyStatesError.numericalFailure
            }

            if abs(currentResidual) < 1e-10 {
                appendRoot(currentTemperature)
            } else if previousResidual * currentResidual < 0 {
                var lower = previousTemperature
                var upper = currentTemperature
                var lowerResidual = previousResidual

                for _ in 0..<bisectionIterations {
                    let midpoint = 0.5 * (lower + upper)
                    let midpointResidual = residual(midpoint)

                    if abs(midpointResidual) < 1e-13 {
                        lower = midpoint
                        upper = midpoint
                        break
                    }

                    if lowerResidual * midpointResidual <= 0 {
                        upper = midpoint
                    } else {
                        lower = midpoint
                        lowerResidual = midpointResidual
                    }
                }

                appendRoot(0.5 * (lower + upper))
            }

            previousTemperature = currentTemperature
            previousResidual = currentResidual
        }

        roots.sort()

        let states = roots.compactMap {
            temperature -> NonIsothermalCSTRSteadyState? in
            let conversion = materialConversion(temperature)
            guard conversion >= 0, conversion <= 1 else {
                return nil
            }

            return .init(
                temperature: temperature,
                conversion: conversion,
                outletConcentrationA:
                    input.inletConcentrationA * (1 - conversion),
                rateConstant: rateConstant(temperature),
                residual: residual(temperature)
            )
        }

        guard let first = states.first, let last = states.last else {
            throw NonIsothermalCSTRSteadyStatesError.noSteadyStateFound
        }

        let middle = states.count >= 3
            ? states[states.count / 2]
            : nil

        let description: String
        switch states.count {
        case 1:
            description = "One physical steady state was found."
        case 2:
            description =
                "Two intersections were found; the parameters are near a multiplicity boundary."
        case 3:
            description =
                "Three physical steady states were found, indicating classical CSTR multiplicity."
        default:
            description =
                "\(states.count) numerical intersections were found."
        }

        guard
            states.count <= 8,
            states.allSatisfy({
                $0.temperature.isFinite
                && $0.conversion.isFinite
                && $0.outletConcentrationA.isFinite
                && $0.rateConstant.isFinite
                && $0.residual.isFinite
            })
        else {
            throw NonIsothermalCSTRSteadyStatesError.numericalFailure
        }

        return .init(
            steadyStates: states,
            steadyStateCount: states.count,
            minimumSearchTemperature: minimumTemperature,
            maximumSearchTemperature: maximumTemperature,
            lowestTemperatureState: first,
            middleTemperatureState: middle,
            highestTemperatureState: last,
            multiplicityDescription: description,
            modelName:
                "Steady-state intersection analysis for an exothermic first-order CSTR",
            limitationDescription:
                "Finds intersections between material and energy balances. It identifies mathematical steady states but does not perform a full dynamic stability analysis."
        )
    }
}
