import Foundation

struct HeatExchangePFREngine: Sendable {
    private let gasConstant = 8.31446261815324
    private let integrationIntervals = 4000

    func calculate(
        _ input: HeatExchangePFRInput
    ) throws -> HeatExchangePFRResult {
        let values = [
            input.inletConcentrationA,
            input.inletVolumetricFlowRate,
            input.preExponentialFactor,
            input.activationEnergy,
            input.inletTemperature,
            input.adiabaticTemperatureRise,
            input.coolantTemperature,
            input.heatRemovalCoefficient,
            input.targetConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw HeatExchangePFRError.nonFiniteInput
        }
        guard
            input.inletConcentrationA > 0,
            input.inletVolumetricFlowRate > 0,
            input.preExponentialFactor > 0
        else {
            throw HeatExchangePFRError.nonPositiveFeedOrFactor
        }
        guard input.activationEnergy >= 0 else {
            throw HeatExchangePFRError.negativeActivationEnergy
        }
        guard input.inletTemperature > 0, input.coolantTemperature > 0 else {
            throw HeatExchangePFRError.nonPositiveTemperature
        }
        guard input.heatRemovalCoefficient >= 0 else {
            throw HeatExchangePFRError.negativeHeatRemovalCoefficient
        }
        guard input.targetConversion > 0, input.targetConversion < 1 else {
            throw HeatExchangePFRError.conversionOutOfRange
        }

        func rateConstant(_ temperature: Double) -> Double {
            input.preExponentialFactor
            * exp(-input.activationEnergy / (gasConstant * temperature))
        }

        func derivatives(
            conversion: Double,
            temperature: Double
        ) -> (spaceTime: Double, temperature: Double) {
            let denominator =
                rateConstant(temperature)
                * (1 - conversion)

            return (
                1 / denominator,
                input.adiabaticTemperatureRise
                - input.heatRemovalCoefficient
                * (temperature - input.coolantTemperature)
                / denominator
            )
        }

        let dx = input.targetConversion / Double(integrationIntervals)
        var spaceTime = 0.0
        var temperature = input.inletTemperature
        var minimumTemperature = temperature
        var maximumTemperature = temperature

        for index in 0..<integrationIntervals {
            let x = Double(index) * dx
            let k1 = derivatives(conversion: x, temperature: temperature)
            let k2 = derivatives(
                conversion: x + 0.5 * dx,
                temperature: temperature + 0.5 * dx * k1.temperature
            )
            let k3 = derivatives(
                conversion: x + 0.5 * dx,
                temperature: temperature + 0.5 * dx * k2.temperature
            )
            let k4 = derivatives(
                conversion: x + dx,
                temperature: temperature + dx * k3.temperature
            )

            spaceTime += dx / 6 * (
                k1.spaceTime
                + 2 * k2.spaceTime
                + 2 * k3.spaceTime
                + k4.spaceTime
            )

            temperature += dx / 6 * (
                k1.temperature
                + 2 * k2.temperature
                + 2 * k3.temperature
                + k4.temperature
            )

            guard spaceTime.isFinite, temperature.isFinite, temperature > 0 else {
                throw HeatExchangePFRError.numericalFailure
            }

            minimumTemperature = min(minimumTemperature, temperature)
            maximumTemperature = max(maximumTemperature, temperature)
        }

        let volume = input.inletVolumetricFlowRate * spaceTime
        let inletK = rateConstant(input.inletTemperature)
        let outletK = rateConstant(temperature)
        let outletConcentration =
            input.inletConcentrationA * (1 - input.targetConversion)
        let released = input.adiabaticTemperatureRise * input.targetConversion
        let retained = temperature - input.inletTemperature
        let removed = released - retained
        let retainedFraction = abs(released) > 1e-14
            ? retained / released
            : 0

        func adiabaticIntegrand(_ conversion: Double) -> Double {
            let adiabaticTemperature =
                input.inletTemperature
                + input.adiabaticTemperatureRise * conversion
            return 1 / (
                rateConstant(adiabaticTemperature)
                * (1 - conversion)
            )
        }

        var sum =
            adiabaticIntegrand(0)
            + adiabaticIntegrand(input.targetConversion)

        for index in 1..<integrationIntervals {
            let x = Double(index) * dx
            sum += (index.isMultiple(of: 2) ? 2 : 4)
                * adiabaticIntegrand(x)
        }

        let adiabaticSpaceTime = dx / 3 * sum
        let adiabaticVolume =
            input.inletVolumetricFlowRate * adiabaticSpaceTime
        let volumeRatio = volume / adiabaticVolume

        let results = [
            spaceTime,
            volume,
            temperature,
            minimumTemperature,
            maximumTemperature,
            inletK,
            outletK,
            outletConcentration,
            released,
            removed,
            retainedFraction,
            adiabaticVolume,
            volumeRatio
        ]

        guard results.allSatisfy(\.isFinite), spaceTime > 0, volume > 0 else {
            throw HeatExchangePFRError.numericalFailure
        }

        return .init(
            requiredSpaceTime: spaceTime,
            requiredReactorVolume: volume,
            outletTemperature: temperature,
            minimumTemperature: minimumTemperature,
            maximumTemperature: maximumTemperature,
            inletRateConstant: inletK,
            outletRateConstant: outletK,
            outletConcentrationA: outletConcentration,
            heatReleasedTemperatureEquivalent: released,
            heatRemovedTemperatureEquivalent: removed,
            retainedHeatFraction: retainedFraction,
            adiabaticReactorVolume: adiabaticVolume,
            heatExchangeToAdiabaticVolumeRatio: volumeRatio,
            modelName:
                "Heat-exchange PFR with first-order Arrhenius kinetics and constant coolant temperature",
            limitationDescription:
                "Integrates coupled space-time and temperature balances over conversion with RK4. Assumes constant properties, constant coolant temperature and no radial gradients."
        )
    }
}
