import Foundation

struct HeatExchangeCSTREngine: Sendable {
    private let gasConstant = 8.31446261815324

    func calculate(
        _ input: HeatExchangeCSTRInput
    ) throws -> HeatExchangeCSTRResult {
        let values = [
            input.inletConcentrationA,
            input.inletVolumetricFlowRate,
            input.preExponentialFactor,
            input.activationEnergy,
            input.inletTemperature,
            input.adiabaticTemperatureRise,
            input.coolantTemperature,
            input.heatRemovalNumber,
            input.targetConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw HeatExchangeCSTRError.nonFiniteInput
        }
        guard
            input.inletConcentrationA > 0,
            input.inletVolumetricFlowRate > 0,
            input.preExponentialFactor > 0
        else {
            throw HeatExchangeCSTRError.nonPositiveFeedOrFactor
        }
        guard input.activationEnergy >= 0 else {
            throw HeatExchangeCSTRError.negativeActivationEnergy
        }
        guard input.inletTemperature > 0, input.coolantTemperature > 0 else {
            throw HeatExchangeCSTRError.nonPositiveTemperature
        }
        guard input.heatRemovalNumber >= 0 else {
            throw HeatExchangeCSTRError.negativeHeatRemovalNumber
        }
        guard input.targetConversion > 0, input.targetConversion < 1 else {
            throw HeatExchangeCSTRError.conversionOutOfRange
        }

        let outletTemperature = (
            input.inletTemperature
            + input.adiabaticTemperatureRise * input.targetConversion
            + input.heatRemovalNumber * input.coolantTemperature
        ) / (1 + input.heatRemovalNumber)

        let adiabaticTemperature =
            input.inletTemperature
            + input.adiabaticTemperatureRise * input.targetConversion

        guard outletTemperature > 0, adiabaticTemperature > 0 else {
            throw HeatExchangeCSTRError.nonPositiveTemperature
        }

        func rateConstant(_ temperature: Double) -> Double {
            input.preExponentialFactor
            * exp(-input.activationEnergy / (gasConstant * temperature))
        }

        let outletK = rateConstant(outletTemperature)
        let adiabaticK = rateConstant(adiabaticTemperature)
        let spaceTime = input.targetConversion
            / (outletK * (1 - input.targetConversion))
        let volume = input.inletVolumetricFlowRate * spaceTime
        let adiabaticSpaceTime = input.targetConversion
            / (adiabaticK * (1 - input.targetConversion))
        let adiabaticVolume =
            input.inletVolumetricFlowRate * adiabaticSpaceTime
        let outletConcentration =
            input.inletConcentrationA * (1 - input.targetConversion)
        let outletRate = outletK * outletConcentration

        let released = input.adiabaticTemperatureRise * input.targetConversion
        let retained = outletTemperature - input.inletTemperature
        let removed = released - retained
        let retainedFraction = abs(released) > 1e-14
            ? retained / released
            : 0
        let volumeRatio = volume / adiabaticVolume

        let results = [
            outletTemperature,
            spaceTime,
            volume,
            outletK,
            outletConcentration,
            outletRate,
            adiabaticTemperature,
            removed,
            retainedFraction,
            adiabaticVolume,
            volumeRatio
        ]

        guard results.allSatisfy(\.isFinite), volume > 0, spaceTime > 0 else {
            throw HeatExchangeCSTRError.numericalFailure
        }

        return .init(
            outletTemperature: outletTemperature,
            requiredSpaceTime: spaceTime,
            requiredReactorVolume: volume,
            outletRateConstant: outletK,
            outletConcentrationA: outletConcentration,
            outletReactionRate: outletRate,
            adiabaticOutletTemperature: adiabaticTemperature,
            heatRemovedTemperatureEquivalent: removed,
            retainedHeatFraction: retainedFraction,
            adiabaticReactorVolume: adiabaticVolume,
            heatExchangeToAdiabaticVolumeRatio: volumeRatio,
            modelName:
                "Target-conversion heat-exchange CSTR with first-order Arrhenius kinetics",
            limitationDescription:
                "Uses T = (T_in + ΔT_ad X + H T_c)/(1+H), where H = UA/(ρC_pv₀). Assumes perfect mixing, constant properties and one irreversible first-order reaction."
        )
    }
}
