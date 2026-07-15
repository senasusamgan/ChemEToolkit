import Foundation

struct AdiabaticPFREngine:
    Sendable {

    private let gasConstant =
        8.31446261815324

    private let integrationIntervals =
        2000

    func calculate(
        _ input:
            AdiabaticPFRInput
    ) throws
        -> AdiabaticPFRResult {

        let values = [
            input.inletConcentrationA,
            input.inletVolumetricFlowRate,
            input.preExponentialFactor,
            input.activationEnergy,
            input.inletTemperature,
            input.adiabaticTemperatureRise,
            input.targetConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AdiabaticPFRError
                .nonFiniteInput
        }

        guard
            input.inletConcentrationA > 0,
            input.inletVolumetricFlowRate > 0,
            input.preExponentialFactor > 0
        else {
            throw AdiabaticPFRError
                .nonPositiveFeedOrFactor
        }

        guard input.activationEnergy >= 0 else {
            throw AdiabaticPFRError
                .negativeActivationEnergy
        }

        guard
            input.targetConversion > 0,
            input.targetConversion < 1
        else {
            throw AdiabaticPFRError
                .conversionOutOfRange
        }

        let outletTemperature =
            input.inletTemperature
            + input.adiabaticTemperatureRise
            * input.targetConversion

        guard
            input.inletTemperature > 0,
            outletTemperature > 0
        else {
            throw AdiabaticPFRError
                .nonPositiveTemperature
        }

        func temperature(
            at conversion: Double
        ) -> Double {
            input.inletTemperature
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

        let step =
            input.targetConversion
            / Double(
                integrationIntervals
            )

        var sum =
            integrand(at: 0)
            + integrand(
                at: input.targetConversion
            )

        for index in 1..<integrationIntervals {
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

        let requiredSpaceTime =
            step / 3 * sum

        let requiredVolume =
            input.inletVolumetricFlowRate
            * requiredSpaceTime

        let inletRateConstant =
            rateConstant(at: 0)

        let outletRateConstant =
            rateConstant(
                at: input.targetConversion
            )

        let isothermalSpaceTime =
            -log(
                1 - input.targetConversion
            )
            / inletRateConstant

        let isothermalVolume =
            input.inletVolumetricFlowRate
            * isothermalSpaceTime

        let volumeRatio =
            isothermalVolume
            / requiredVolume

        let outletConcentration =
            input.inletConcentrationA
            * (
                1 - input.targetConversion
            )

        let outletReactionRate =
            outletRateConstant
            * outletConcentration

        let results = [
            requiredSpaceTime,
            requiredVolume,
            isothermalSpaceTime,
            isothermalVolume,
            volumeRatio,
            outletTemperature,
            inletRateConstant,
            outletRateConstant,
            outletConcentration,
            outletReactionRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            requiredSpaceTime > 0,
            requiredVolume > 0,
            isothermalSpaceTime > 0,
            isothermalVolume > 0,
            volumeRatio > 0,
            outletTemperature > 0,
            inletRateConstant > 0,
            outletRateConstant > 0,
            outletConcentration > 0,
            outletReactionRate > 0
        else {
            throw AdiabaticPFRError
                .numericalFailure
        }

        return .init(
            requiredSpaceTime:
                requiredSpaceTime,
            requiredReactorVolume:
                requiredVolume,
            isothermalSpaceTimeAtInletTemperature:
                isothermalSpaceTime,
            isothermalReactorVolume:
                isothermalVolume,
            isothermalToAdiabaticVolumeRatio:
                volumeRatio,
            outletTemperature:
                outletTemperature,
            temperatureChange:
                outletTemperature
                - input.inletTemperature,
            inletRateConstant:
                inletRateConstant,
            outletRateConstant:
                outletRateConstant,
            outletConcentrationA:
                outletConcentration,
            outletReactionRate:
                outletReactionRate,
            modelName:
                "Constant-density adiabatic PFR with first-order Arrhenius kinetics and T = T₀ + ΔT_ad X",
            limitationDescription:
                "Assumes one irreversible first-order reaction, constant heat capacity, no radial gradients and no heat loss. The design integral uses 2000-interval Simpson integration."
        )
    }
}
