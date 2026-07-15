import Foundation

struct AdiabaticCSTREngine:
    Sendable {

    private let gasConstant =
        8.31446261815324

    func calculate(
        _ input:
            AdiabaticCSTRInput
    ) throws
        -> AdiabaticCSTRResult {

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
            throw AdiabaticCSTRError
                .nonFiniteInput
        }

        guard
            input.inletConcentrationA > 0,
            input.inletVolumetricFlowRate > 0,
            input.preExponentialFactor > 0
        else {
            throw AdiabaticCSTRError
                .nonPositiveFeedOrFactor
        }

        guard input.activationEnergy >= 0 else {
            throw AdiabaticCSTRError
                .negativeActivationEnergy
        }

        guard
            input.targetConversion > 0,
            input.targetConversion < 1
        else {
            throw AdiabaticCSTRError
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
            throw AdiabaticCSTRError
                .nonPositiveTemperature
        }

        let outletRateConstant =
            input.preExponentialFactor
            * exp(
                -input.activationEnergy
                / (
                    gasConstant
                    * outletTemperature
                )
            )

        let inletRateConstant =
            input.preExponentialFactor
            * exp(
                -input.activationEnergy
                / (
                    gasConstant
                    * input.inletTemperature
                )
            )

        let requiredSpaceTime =
            input.targetConversion
            / (
                outletRateConstant
                * (
                    1 - input.targetConversion
                )
            )

        let requiredVolume =
            input.inletVolumetricFlowRate
            * requiredSpaceTime

        let isothermalSpaceTime =
            input.targetConversion
            / (
                inletRateConstant
                * (
                    1 - input.targetConversion
                )
            )

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
            outletTemperature,
            outletRateConstant,
            outletConcentration,
            outletReactionRate,
            isothermalSpaceTime,
            isothermalVolume,
            volumeRatio
        ]

        guard
            results.allSatisfy(\.isFinite),
            requiredSpaceTime > 0,
            requiredVolume > 0,
            outletTemperature > 0,
            outletRateConstant > 0,
            outletConcentration > 0,
            outletReactionRate > 0,
            isothermalSpaceTime > 0,
            isothermalVolume > 0,
            volumeRatio > 0
        else {
            throw AdiabaticCSTRError
                .numericalFailure
        }

        return .init(
            requiredSpaceTime:
                requiredSpaceTime,
            requiredReactorVolume:
                requiredVolume,
            outletTemperature:
                outletTemperature,
            temperatureChange:
                outletTemperature
                - input.inletTemperature,
            outletRateConstant:
                outletRateConstant,
            outletConcentrationA:
                outletConcentration,
            outletReactionRate:
                outletReactionRate,
            isothermalSpaceTimeAtInletTemperature:
                isothermalSpaceTime,
            isothermalReactorVolume:
                isothermalVolume,
            isothermalToAdiabaticVolumeRatio:
                volumeRatio,
            modelName:
                "Adiabatic CSTR sizing at a specified conversion with first-order Arrhenius kinetics",
            limitationDescription:
                "Assumes one irreversible first-order reaction, constant density, constant heat capacity, perfect mixing and T_out = T_in + ΔT_ad X. Multiple steady states are not analyzed in this target-conversion sizing form."
        )
    }
}
